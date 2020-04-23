load("@io_bazel_rules_go//go/private:common.bzl", "env_execute", "executable_extension")

CuePkg = provider(
    doc = "Collects files from cue_library for use in downstream cue_export",
    fields = {
        "transitive_pkgs": "Cue pkg zips for this target and its dependencies",
    },
)

def _collect_transitive_pkgs(pkg, deps):
    "Cue evaluation requires all transitive .cue source files"
    return depset(
        [pkg],
        transitive = [dep[CuePkg].transitive_pkgs for dep in deps],
        # Provide .cue sources from dependencies first
        order = "postorder",
    )

def _cue_def(ctx):
    "Cue def library"
    srcs_zip = _zip_src(ctx, ctx.files.srcs)
    merged = _pkg_merge(ctx, srcs_zip)
    def_out = ctx.actions.declare_file(ctx.label.name + "~def.json")

    args = ctx.actions.args()
    args.add(ctx.executable._cue.path)
    args.add(merged.path)
    args.add(def_out.path)

    ctx.actions.run_shell(
        mnemonic = "CueDef",
        tools = [ctx.executable._cue],
        arguments = [args],
        command = """
set -euo pipefail

CUE=$1; shift
PKGZIP=$1; shift
OUT=$1; shift

unzip -q ${PKGZIP}
${CUE} def -o ${OUT}
""",
        inputs = [merged],
        outputs = [def_out],
        use_default_shell_env = True,
    )

    return def_out

def _cue_library_impl(ctx):
    """cue_library validates a cue package, bundles up the files into a
    zip, and collects all transitive dep zips.
    Args:
      ctx: The Bazel build context
    Returns:
      The cue_library rule.
    """

    def_out = _cue_def(ctx)

    # Create the manifest input to zipper
    pkg = "pkg/"+ctx.attr.importpath.split(":")[0]
    manifest = "".join([pkg+"/"+src.basename + "=" + src.path + "\n" for src in ctx.files.srcs])
    manifest_file = ctx.actions.declare_file(ctx.label.name + "~manifest")
    ctx.actions.write(manifest_file, manifest)

    pkg = ctx.actions.declare_file(ctx.label.name + ".zip")

    args = ctx.actions.args()
    args.add("c")
    args.add(pkg.path)
    args.add("@" + manifest_file.path)


    ctx.actions.run(
        mnemonic = "CuePkg",
        outputs = [pkg],
        inputs = [def_out, manifest_file] + ctx.files.srcs,
        executable = ctx.executable._zipper,
        arguments = [args],
    )

    return [
        DefaultInfo(
            files = depset([pkg]),
            runfiles = ctx.runfiles(files = [pkg]),
        ),
        CuePkg(
            transitive_pkgs = depset(
                [pkg],
                transitive = [dep[CuePkg].transitive_pkgs for dep in ctx.attr.deps],
                # Provide .cue sources from dependencies first
                order = "postorder",
            ),
        ),
    ]

def _zip_src(ctx, srcs):
    # Generate a zip file containing the src file

    zipper_list_content = "".join([src.basename + "=" + src.path + "\n" for src in srcs])
    zipper_list = ctx.actions.declare_file(ctx.label.name + "~zipper.txt")
    ctx.actions.write(zipper_list, zipper_list_content)

    src_zip = ctx.actions.declare_file(ctx.label.name + "~src.zip")

    args = ctx.actions.args()
    args.add("c")
    args.add(src_zip.path)
    args.add("@" + zipper_list.path)

    ctx.actions.run(
        mnemonic = "zipper",
        executable = ctx.executable._zipper,
        arguments = [args],
        inputs = [zipper_list] + srcs,
        outputs = [src_zip],
        use_default_shell_env = True,
    )

    return src_zip

def _pkg_merge(ctx, src_zip):
    merged = ctx.actions.declare_file(ctx.label.name + "~merged.zip")

    args = ctx.actions.args()
    args.add_joined(["-o", merged.path], join_with = "=")
    inputs = depset(
        [src_zip],
        transitive = [dep[CuePkg].transitive_pkgs for dep in ctx.attr.deps],
        # Provide .cue sources from dependencies first
        order = "postorder",
    )
    for dep in inputs.to_list():
        args.add(dep.path)

    ctx.actions.run(
        mnemonic = "CuePkgMerge",
        executable = ctx.executable._zipmerge,
        arguments = [args],
        inputs = inputs,
        outputs = [merged],
        use_default_shell_env = True,
    )

    return merged

def _cue_export(ctx, merged, output):
    """_cue_export performs an action to export a single Cue file."""

    # The Cue CLI expects inputs like
    # cue export <flags> <input_filename>
    args = ctx.actions.args()

    args.add(ctx.executable._cue.path)
    args.add(merged.path)
    args.add(ctx.file.src.basename)
    args.add(output.path)

    if ctx.attr.escape:
        args.add("--escape")
    #if ctx.attr.ignore:
    #    args.add("--ignore")
    #if ctx.attr.simplify:
    #    args.add("--simplify")
    #if ctx.attr.trace:
    #    args.add("--trace")
    #if ctx.attr.verbose:
    #    args.add("--verbose")
    #if ctx.attr.debug:
    #    args.add("--debug")

    args.add_joined(["--out", ctx.attr.output_format], join_with = "=")
    #args.add(input.path)

    ctx.actions.run_shell(
        mnemonic = "CueExport",
        tools = [ctx.executable._cue],
        arguments = [args],
        command = """
set -euo pipefail

CUE=$1; shift
PKGZIP=$1; shift
SRC=$1; shift
OUT=$1; shift

unzip -q ${PKGZIP}
${CUE} export -o ${OUT} $@ ${SRC}
""",
        inputs = [merged],
        outputs = [output],
        use_default_shell_env = True,
    )

def _cue_export_impl(ctx):
    src_zip = _zip_src(ctx, [ctx.file.src])
    merged = _pkg_merge(ctx, src_zip)
    _cue_export(ctx, merged, ctx.outputs.export)
    return DefaultInfo(
        files = depset([ctx.outputs.export]),
        runfiles = ctx.runfiles(files = [ctx.outputs.export]),
    )



_cue_deps_attr = attr.label_list(
    doc = "cue_library targets to include in the evaluation",
    providers = [CuePkg],
    allow_files = False,
)

_cue_library_attrs = {
    "srcs": attr.label_list(
        doc = "Cue source files",
        allow_files = [".cue"],
        allow_empty = False,
        mandatory = True,
    ),
    "deps": _cue_deps_attr,
    "importpath": attr.string(
        doc = "Cue import path under pkg/",
        mandatory = True,
    ),
    "_cue": attr.label(
        default = Label("//cue:cue_runtime"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    ),
    "_zipper": attr.label(
        default = Label("@bazel_tools//tools/zip:zipper"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    ),
    "_zipmerge": attr.label(
        default = Label("@io_rsc_zipmerge//:zipmerge"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    ),
}

cue_library = rule(
    implementation = _cue_library_impl,
    attrs = _cue_library_attrs,
)

def _strip_extension(path):
    """Removes the final extension from a path."""
    components = path.split(".")
    components.pop()
    return ".".join(components)

def _cue_export_outputs(src, output_name, output_format):
    """Get map of cue_export outputs.
    Note that the arguments to this function are named after attributes on the rule.
    Args:
      src: The rule's `src` attribute
      output_name: The rule's `output_name` attribute
      output_format: The rule's `output_format` attribute
    Returns:
      Outputs for the cue_export
    """

    outputs = {
        "export": output_name or _strip_extension(src.name) + "." + output_format,
    }

    return outputs

_cue_export_attrs = {
    "src": attr.label(
        doc = "Cue entrypoint file",
        mandatory = True,
        allow_single_file = [".cue"],
    ),
    "escape": attr.bool(
        default = False,
        doc = "Use HTML escaping.",
    ),
    #debug            give detailed error info
    #ignore           proceed in the presence of errors
    #simplify         simplify output
    #trace            trace computation
    #verbose          print information about progress
    "output_name": attr.string(
        doc = """Name of the output file, including the extension.
By default, this is based on the `src` attribute: if `foo.cue` is
the `src` then the output file is `foo.json.`.
You can override this to be any other name.
Note that some tooling may assume that the output name is derived from
the input name, so use this attribute with caution.""",
        default = "",
    ),
    "output_format": attr.string(
        doc = "Output format",
        default = "json",
        values = [
            "json",
            "yaml",
        ],
    ),
    "deps": _cue_deps_attr,
    "_cue": attr.label(
        default = Label("//cue:cue_runtime"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    ),
    "_zipper": attr.label(
        default = Label("@bazel_tools//tools/zip:zipper"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    ),
    "_zipmerge": attr.label(
        default = Label("@io_rsc_zipmerge//:zipmerge"),
        executable = True,
        allow_single_file = True,
        cfg = "host",
    )
}

cue_export = rule(
    implementation = _cue_export_impl,
    attrs = _cue_export_attrs,
    outputs = _cue_export_outputs,
)

# We can't disable timeouts on Bazel, but we can set them to large values.
_CUE_REPOSITORY_TIMEOUT = 86400

def _cue_repository_impl(ctx):
    # Download the repository archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
        type = ctx.attr.type,
    )

    # Repository is fetched. Determine if build file generation is needed.
    build_file_names = ctx.attr.build_file_name.split(",")
    existing_build_file = ""
    for name in build_file_names:
        path = ctx.path(name)
        if path.exists and not env_execute(ctx, ["test", "-f", path]).return_code:
            existing_build_file = name
            break

    generate = (ctx.attr.build_file_generation == "on" or (not existing_build_file and ctx.attr.build_file_generation == "auto"))

    if generate:
        # Build file generation is needed. Populate Gazelle directive at root build file
        build_file_name = existing_build_file or build_file_names[0]
        if len(ctx.attr.build_directives) > 0:
            ctx.file(
                build_file_name,
                "\n".join(["# " + d for d in ctx.attr.build_directives]),
            )

        # Run Gazelle
        _gazelle = "@com_github_tnarg_rules_cue//:gazelle_binary"
        gazelle = ctx.path(Label(_gazelle))
        cmd = [
            gazelle,
            "-cue_repository_mode",
            "-cue_prefix",
            ctx.attr.importpath,
            "-mode",
            "fix",
            "-repo_root",
            ctx.path(""),
            "-repo_config",
            ctx.path(ctx.attr.build_config)
        ]
        if ctx.attr.build_file_name:
            cmd.extend(["-build_file_name", ctx.attr.build_file_name])
        cmd.extend(ctx.attr.build_extra_args)
        cmd.append(ctx.path(""))
        result = env_execute(ctx, cmd, timeout = _CUE_REPOSITORY_TIMEOUT)
        if result.return_code:
            fail("failed to generate BUILD files for %s: %s" % (
                ctx.attr.importpath,
                result.stderr,
            ))
        if result.stderr:
            print("%s: %s" % (ctx.name, result.stderr))

    _patch(ctx)

# Copied from @bazel_tools//tools/build_defs/repo:utils.bzl
def _patch(ctx):
    """Implementation of patching an already extracted repository"""
    bash_exe = ctx.os.environ["BAZEL_SH"] if "BAZEL_SH" in ctx.os.environ else "bash"
    for patchfile in ctx.attr.patches:
        command = "{patchtool} {patch_args} < {patchfile}".format(
            patchtool = ctx.attr.patch_tool,
            patchfile = ctx.path(patchfile),
            patch_args = " ".join([
                "'%s'" % arg
                for arg in ctx.attr.patch_args
            ]),
        )
        st = ctx.execute([bash_exe, "-c", command])
        if st.return_code:
            fail("Error applying patch %s:\n%s%s" %
                 (str(patchfile), st.stderr, st.stdout))
    for cmd in ctx.attr.patch_cmds:
        st = ctx.execute([bash_exe, "-c", cmd])
        if st.return_code:
            fail("Error applying patch command %s:\n%s%s" %
                 (cmd, st.stdout, st.stderr))

cue_repository = repository_rule(
    implementation = _cue_repository_impl,
    attrs = {
        # Fundamental attributes of a cue repository
        "importpath": attr.string(mandatory = True),

        # Attributes for a repository that should be downloaded via HTTP.
        "urls": attr.string_list(),
        "strip_prefix": attr.string(),
        "type": attr.string(),
        "sha256": attr.string(),

        # Attributes for a repository that needs automatic build file generation
        "build_file_name": attr.string(default = "BUILD.bazel,BUILD"),
        "build_file_generation": attr.string(
            default = "auto",
            values = [
                "on",
                "auto",
                "off",
            ],
        ),
        "build_extra_args": attr.string_list(),
        "build_config": attr.label(default= "@bazel_gazelle_go_repository_config//:WORKSPACE"),
        "build_directives": attr.string_list(default = []),

        # Patches to apply after running gazelle.
        "patches": attr.label_list(),
        "patch_tool": attr.string(default = "patch"),
        "patch_args": attr.string_list(default = ["-p0"]),
        "patch_cmds": attr.string_list(default = []),
    },
)

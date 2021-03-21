# CUE Rules for Bazel

## Rules
* [cue_export](#cue_export)
* [cue_library](#cue_library)

## Overview
These build rules are used for building [CUE][cue] projects with Bazel.

[cue]: https://cuelang.org/

## Setup
To use the CUE rules, add the following to your
`WORKSPACE` file to add the external repositories for CUE, making sure to use the latest
published versions:

```py
http_archive(
    name = "com_github_tnarg_rules_cue",
    # Make sure to check for the latest version when you install
    url = "https://github.com/tnarg/rules_cue/archive/be98df2981025bf1389510797ea11e0e37aa761f.zip",
    strip_prefix = "rules_cue-be98df2981025bf1389510797ea11e0e37aa761f",
    sha256 = "ee6eea3de252ebc8fb05c23e8d370e32c4783b36cd1c6ec9ea72411a086ac35e",
)

load("@com_github_tnarg_rules_cue//cue:deps.bzl", "cue_register_toolchains")
load("@com_github_tnarg_rules_cue//go.bzl", cue_go_modules = "go_modules")

cue_go_modules()

cue_register_toolchains()
```


## Build Rule Reference

<a name="reference-cue_export"></a>
### cue_export

```py
cue_export(name, src, deps=[], output_format=<format>", output_name=<src_filename.cue>)
```

Exports a single CUE entry-point file. The entry-point file may have
dependencies (`cue_library` rules, see below).

| Attribute       | Description                                                                   |
|-----------------|-------------------------------------------------------------------------------|
| `name`          | Unique name for this rule (required)                                          |
| `src`           | Cue compilation entry-point (required).                                       |
| `deps`          | List of dependencies for the `src`. Each dependency is a `cue_library`        |
| `output_format` | It should be one of :value:`json` or :value:`yaml`.                           |
| `output_name`   | Output file name, including extension. Defaults to `<src_name>.json`          |

### cue_library

```py
cue_library(name, srcs, importpath, deps=[])
```

Defines a collection of Cue files that can be depended on by a `cue_export`. Does not generate
any outputs.

| Attribute    | Description                                                                                       |
|--------------|---------------------------------------------------------------------------------------------------|
| `name`       | Unique name for this rule (required)                                                              |
| `srcs`       | CUE files included in this library. Package name MUST match the directory name.                   |
| `importpath` | The source import path of this library. Other .cue files can import this library using this path. |
| `deps`       | Dependencies for the `srcs`. Each dependency is a `cue_library`                                   |

## Gazelle Extension

To use [Gazelle][gazelle] in your project to generate BUILD.bazel files for your .cue files, add gazelle to your WORKSPACE, and then add the following to your repository root BUILD.bazel:

[gazelle]: https://github.com/bazelbuild/bazel-gazelle

```py
load("@bazel_gazelle//:def.bzl", "DEFAULT_LANGUAGES", "gazelle_binary", "gazelle")

gazelle_binary(
    name = "gazelle_binary",
    languages = DEFAULT_LANGUAGES + ["@com_github_tnarg_rules_cue//gazelle/cue"],
    visibility = ["//visibility:public"],
)

# gazelle:prefix github.com/example/project
gazelle(
    name = "gazelle",
    gazelle = "//:gazelle_binary",
)
```

load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# https://github.com/cuelang/cue/releases/download/v0.4.0/cue_v0.4.0_linux_amd64.tar.gz

_cue_runtimes = {
    "0.4.0": [{
        "os": "linux",
        "arch": "amd64",
        "sha256": "a118177d9c605b4fc1a61c15a90fddf57a661136c868dbcaa9d2406c95897949",
    }, {
        "os": "darwin",
        "arch": "amd64",
        "sha256": "24717a72b067a4d8f4243b51832f4a627eaa7e32abc4b9117b0af9aa63ae0332",
    }, {
        "os": "windows",
        "arch": "amd64",
        "sha256": "13a2db61e78473db0fab0530e8ebf70aa37ed6fb88ee14df240880ec7e70c0f1",
    }],
}

def cue_register_toolchains(version = "0.4.0"):
    for platform in _cue_runtimes[version]:
        suffix = "tar.gz"
        if platform["os"] == "windows":
            suffix = "zip"
        http_archive(
            name = "cue_runtime_%s_%s" % (platform["os"], platform["arch"]),
            build_file_content = """exports_files(["cue"], visibility = ["//visibility:public"])""",
            url = "https://github.com/cuelang/cue/releases/download/v%s/cue_v%s_%s_%s.%s" % (version, version, platform["os"], platform["arch"], suffix),
            sha256 = platform["sha256"],
        )

def cue_rules_dependencies():
    go_repository(
        name = "com_github_cockroachdb_apd_v2",
        importpath = "github.com/cockroachdb/apd/v2",
        sum = "h1:y1Rh3tEU89D+7Tgbw+lp52T6p/GJLpDmNvr10UWqLTE=",
        version = "v2.0.1",
    )

    go_repository(
        name = "com_github_mpvl_unique",
        importpath = "github.com/mpvl/unique",
        sum = "h1:D5x39vF5KCwKQaw+OC9ZPiLVHXz3UFw2+psEX+gYcto=",
        version = "v0.0.0-20150818121801-cbe035fff7de",
    )

    go_repository(
        name = "com_github_pkg_errors",
        importpath = "github.com/pkg/errors",
        sum = "h1:iURUrRGxPUNPdy5/HRSm+Yj6okJ6UtLINN0Q9M4+h3I=",
        version = "v0.8.1",
    )

    go_repository(
        name = "org_cuelang_go",
        importpath = "cuelang.org/go",
        sum = "h1:RIZpXgS3nw+hWFDbxm5peKo3XHIDJTpcaS9TCmpcVrA=",
        version = "v0.1.1",
    )

    go_repository(
        name = "org_golang_x_xerrors",
        importpath = "golang.org/x/xerrors",
        sum = "h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4=",
        version = "v0.0.0-20191204190536-9bdfabe68543",
    )

    go_repository(
        name = "com_github_iancoleman_strcase",
        importpath = "github.com/iancoleman/strcase",
        sum = "h1:VHgatEHNcBFEB7inlalqfNqw65aNkM1lGX2yt3NmbS8=",
        version = "v0.0.0-20191112232945-16388991a334",
    )

    go_repository(
        name = "io_rsc_zipmerge",
        importpath = "rsc.io/zipmerge",
        sum = "h1:SQ3COGthAQ0mTF+xfVFKwmYag+U/QmnUVhNs4YEP8hQ=",
        version = "v0.0.0-20160407035457-24e6c1052c64",
    )

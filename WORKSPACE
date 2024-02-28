workspace(name = "com_github_tnarg_rules_cue")

#
# Go+Gazelle for Gazelle plugin
#
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "51dc53293afe317d2696d4d6433a4c33feedb7748a9e352072e2ec3c0dafd2c6",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.40.1/rules_go-v0.40.1.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.40.1/rules_go-v0.40.1.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "d3fa66a39028e97d76f9e2db8f1b0c11c099e8e01bf363a923074784e451f809",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.33.0/bazel-gazelle-v0.33.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.33.0/bazel-gazelle-v0.33.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

go_repository(
    name = "com_github_cockroachdb_apd_v3",
    importpath = "github.com/cockroachdb/apd/v3",
    sum = "h1:79kHCn4tO0VGu3W0WujYrMjBDk8a2H4KEUYcXf7whcg=",
    version = "v3.2.0",
)

go_repository(
    name = "com_github_go_quicktest_qt",
    importpath = "github.com/go-quicktest/qt",
    sum = "h1:I7iSLgIwNp0E0UnSvKJzs7ig0jg/Iq83zsZjtQNW7jY=",
    version = "v1.100.0",
)

go_repository(
    name = "com_github_google_shlex",
    importpath = "github.com/google/shlex",
    sum = "h1:El6M4kTTCOh6aBiKaUGG7oYTSPP8MxqL4YI3kZKwcP4=",
    version = "v0.0.0-20191202100458-e7afc7fbc510",
)

go_repository(
    name = "com_github_mitchellh_go_wordwrap",
    importpath = "github.com/mitchellh/go-wordwrap",
    sum = "h1:TLuKupo69TCn6TQSyGxwI1EblZZEsQ0vMlAFQflz0v0=",
    version = "v1.0.1",
)

go_repository(
    name = "com_github_tetratelabs_wazero",
    importpath = "github.com/tetratelabs/wazero",
    sum = "h1:lpwL5zczFHk2mxKur98035Gig+Z3vd9JURk6lUdZxXY=",
    version = "v1.0.2",
)

go_rules_dependencies()

go_register_toolchains(version = "1.20.8")

gazelle_dependencies()

#
# Eat our own dog food
#
load("//cue:deps.bzl", "cue_register_toolchains")

cue_register_toolchains(version = "0.7.1")

load("//:go.bzl", "go_modules")

# gazelle:repository_macro go.bzl%go_modules
go_modules()

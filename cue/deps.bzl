load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

_cue_runtimes = {
    "0.4.0": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.0/cue_v0.4.0_linux_amd64.tar.gz",
            "sha256": "a118177d9c605b4fc1a61c15a90fddf57a661136c868dbcaa9d2406c95897949",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.0/cue_v0.4.0_darwin_amd64.tar.gz",
            "sha256": "24717a72b067a4d8f4243b51832f4a627eaa7e32abc4b9117b0af9aa63ae0332",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.0/cue_v0.4.0_windows_amd64.zip",
            "sha256": "13a2db61e78473db0fab0530e8ebf70aa37ed6fb88ee14df240880ec7e70c0f1",
        },
    ],
    "0.3.0-beta.3": [
        {
            "os": "Linux",
            "arch": "x86_64",
            "sha256": "3a55f5ab134d39df9ef977e07a544d6db03f21898c02b16607090e90fc01b5eb",
        },
        {
            "os": "Darwin",
            "arch": "x86_64",
            "sha256": "b15779a6fb3112a52ae0f99ba84a136ae859caaccc540447a30bf257e2670c6a",
        },
        {
            "os": "Windows",
            "arch": "x86_64",
            "sha256": "d1cf26fbeb8d731a36f91c36a56165b262dd4952a8eb6804066ad252c52930b8",
        },
    ],
    "0.2.2": [
        {
            "os": "Linux",
            "arch": "x86_64",
            "sha256": "810851e0e7d38192a6d0e09a6fa89ab5ff526ce29c9741f697995601edccb134",
        },
        {
            "os": "Darwin",
            "arch": "x86_64",
            "sha256": "d782602b0387d19cb004eab90b47d51bb207007396450153af751ce7581228be",
        },
        {
            "os": "Windows",
            "arch": "x86_64",
            "sha256": "062d17ea61eec8065af02433277ef42833fc8f139202c5743c31bcf316c0431a",
        },
    ],
    "0.2.0": [
        {
            "os": "Linux",
            "arch": "x86_64",
            "sha256": "36c454c8ab48e3fe1d0bb10a461b8b4e362566b50048a5e2808e221248f373d5",
        },
        {
            "os": "Darwin",
            "arch": "x86_64",
            "sha256": "f38412b855bf5c3b97d2c7358ebaaccc088b707158809bd0fce889bbe050ba61",
        },
        {
            "os": "Windows",
            "arch": "x86_64",
            "sha256": "2d1d7f45c61808ba83692f1aefe804894e19d032aec06a91475cb5923bfa6bc4",
        },
    ],
    "0.1.2": [
        {
            "os": "Linux",
            "arch": "x86_64",
            "sha256": "ad47b69a43197af7a150974969ff51034aa981b4df264c0221dbcc3737280209",
        },
        {
            "os": "Darwin",
            "arch": "x86_64",
            "sha256": "0580c7db622eabfcec8f7946bbd7819b7d38ebf11ac79f918d2deccc3544d443",
        },
        {
            "os": "Windows",
            "arch": "x86_64",
            "sha256": "f24e8ff652ae3bdc5ceca09901570f9894f27c75ce94ee67f0c37544ae5a3c75",
        },
    ],
    "0.1.1": [
        {
            "os": "Linux",
            "arch": "x86_64",
            "sha256": "6405bc947cdd5fbee6f6af4b440000503e548cb45a689c0cb72846bc7a694c9e",
        },
        {
            "os": "Darwin",
            "arch": "x86_64",
            "sha256": "4e4d977bdc41cfa61335dcce8d14b535cde08bdafeb7ea81b81bc6b7ced94cbf",
        },
        {
            "os": "Windows",
            "arch": "x86_64",
            "sha256": "110b0a3b8210142fae362ec4c72481f0d63a0240edf88b4c14a3cb216271878a",
        },
    ]
}

def cue_register_toolchains(version = "0.4.0"):
    for platform in _cue_runtimes[version]:
        suffix = "tar.gz"
        if platform["os"] == "Windows":
            suffix = "zip"

        url = "https://github.com/cuelang/cue/releases/download/v%s/cue_%s_%s_%s.%s" % (version, version, platform["os"], platform["arch"], suffix)
        if "url" in platform:
            url = platform["url"]
        http_archive(
            name = "cue_runtime_%s_%s" % (platform["os"].lower(), platform["arch"]),
            build_file_content = """exports_files(["cue"], visibility = ["//visibility:public"])""",
            url = url,
            sha256 = platform["sha256"],
        )


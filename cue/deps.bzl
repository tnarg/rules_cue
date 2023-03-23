load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

_cue_runtimes = {
    "0.4.3": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_linux_amd64.tar.gz",
            "sha256": "5e7ecb614b5926acfc36eb1258800391ab7c6e6e026fa7cacbfe92006bac895c",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_linux_arm64.tar.gz",
            "sha256": "a8c3f4140d18c324cc69f5de4df0566e529e1636cff340095a42475799bf3fed",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_darwin_amd64.tar.gz",
            "sha256": "1161254cf38b928b87a7ac1552dc2e12e6c5da298f9ce370d80e5518ddb6513d",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_darwin_arm64.tar.gz",
            "sha256": "3d84b85a7288f94301a4726dcf95b2d92c8ff796c4d45c4733fbdcc04ceaf21d",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_windows_amd64.zip",
            "sha256": "67f76e36809565c1396cea1b44978d98807d980d55a7ddc3979396d34fac1037",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.3/cue_v0.4.3_windows_arm64.zip",
            "sha256": "a87573f32213a72d763dd624a1b63414e3d862ae4cef0b2698652aef380ebe60",
        },
    ],
    "0.4.2": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.2/cue_v0.4.2_linux_amd64.tar.gz",
            "sha256": "d43cf77e54f42619d270b8e4c1836aec87304daf243449c503251e6943f7466a",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.2/cue_v0.4.2_linux_arm64.tar.gz",
            "sha256": "6515c1f1b6fc09d083be533019416b28abd91e5cdd8ef53cd0719a4b4b0cd1c7",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.2/cue_v0.4.2_darwin_amd64.tar.gz",
            "sha256": "3da1576d36950c64acb7d7a7b80f34e5935ac76b9ff607517981eef44a88a31b",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.2/cue_v0.4.2_darwin_arm64.tar.gz",
            "sha256": "21fcfbe52beff7bae510bb6267fe33a5785039bd7d5f32e3c3222c55580dd85c",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.0/cue_v0.4.2_windows_amd64.zip",
            "sha256": "95be4cd6b04b6c729f4f85a551280378d8939773c2eaecd79c70f907b5cae847",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.4.0/cue_v0.4.2_windows_arm64.zip",
            "sha256": "e03325656ca20d464307f68e3070d774af37e5777156ae983e166d7d7aed60df",
        },
    ],
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
    ],
}

def cue_register_toolchains(version = "0.4.2"):
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

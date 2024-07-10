load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_cue_runtimes = {
    "0.9.2": [
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/0.9.2/cue_v0.9.2_darwin_amd64.tar.gz",
            "sha256": "87ebebb8459d579ff791843b3228ca64dc372181456d8e2b4ad4e3f0c607c94d",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.9.2/cue_v0.9.2_darwin_arm64.tar.gz",
            "sha256": "0f01909937c7f1b5b58d55e53a7d5366f3b4f8fc48dc31e391dd55340ea1ae95",
        },
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.9.2/cue_v0.9.2_linux_amd64.tar.gz",
            "sha256": "67c88f6c3bdf884301794c3ec91f9e6e3f660e7de3b7e10cd29fbbd291baac50",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.9.2/cue_v0.9.2_linux_arm64.tar.gz",
            "sha256": "3b90c49faaf3367338bd95db0bf76ec86bf4ca7d175d42a221e27bdc8d265256",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.9.2/cue_v0.9.2_windows_amd64.zip",
            "sha256": "b63616df5dcc13dc968e714d4935d2823600aa5bdda049edbcaeb639c91a1c76",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_windows_arm64.zip",
            "sha256": "30fb3b62889f45da8c79a75c4c8772ea47306e5edca5c921c7ffb9095522ae1c",
        },
    ],
    "0.7.1": [
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_darwin_amd64.tar.gz",
            "sha256": "8bc701670dfd72d009239605c45973dfd95b7bdaaf55b5eb923c1909058b09e4",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_darwin_arm64.tar.gz",
            "sha256": "a163cc7c33adeeb6c3799c9ec20b8c6a36ffe267453301eaef996f717178ac08",
        },
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_linux_amd64.tar.gz",
            "sha256": "dbd548ff02567881cf81834d0e9e035c86a287c887587b9abfd119763ebb9aea",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_linux_arm64.tar.gz",
            "sha256": "6be1cf9ab36baa62466056bbbc1c3ffe259522fd0c35ea196ad10463eab29f75",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_windows_amd64.zip",
            "sha256": "54d2a7f64985bb5f4bdbff8796ee9f290ba7c86ba1d8b98822373d01ebfae19a",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_windows_arm64.zip",
            "sha256": "4583fc57b6e90da51f2397d0c9e65912d18a4dc4a6c946ea4347af91bd9c7f38",
        },
    ],
    "0.7.0": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_linux_amd64.tar.gz",
            "sha256": "6a4306155cbf3f6d89740464dc0921bbaac74b27236a05a92e30cbb5f248d33b",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_linux_arm64.tar.gz",
            "sha256": "8cf589790f806f7a077197d462e71040c8417d1814a1f469e473c468121e823a",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_darwin_amd64.tar.gz",
            "sha256": "b86efef83abe1b0c90a3cf47a490cd6de5c884d0865ad3463f539b0346a39c8b",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_darwin_arm64.tar.gz",
            "sha256": "0b10652945f13a3ccc732855ac24401cd868d64eb6f4f839141ddd93c63d255e",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_windows_amd64.zip",
            "sha256": "50be1c1a622c2544ae834b377293a587a0c08b3ea6c82441ae1d59435eeb5240",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.0/cue_v0.7.0_windows_arm64.zip",
            "sha256": "257ab9a0a2723b84cb24f8f6ae7a9f899ebde49b81371ef9ee1ec34facfa2ccd",
        },
    ],
    "0.6.0": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_linux_amd64.tar.gz",
            "sha256": "3ae7b28e12de2e0554c28d9a9eb3dd919f0640274c925ba0e36de9079af80de2",
        },
        {
            "os": "linux",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_linux_arm64.tar.gz",
            "sha256": "57d9517b6af3e33e7614fa755dfb9ce14c3b05195aaa835fbe8e592db3cee203",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_darwin_amd64.tar.gz",
            "sha256": "960c8d863f18b1e78c7bc5eeb6e720fe20f47ee7311b935b0bbdeeb5430ab0b0",
        },
        {
            "os": "darwin",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_darwin_arm64.tar.gz",
            "sha256": "e5af24a5017f3e60eb0d1647744239c5e53c6e521a311c85930eba18ff1bc87a",
        },
        {
            "os": "windows",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_windows_amd64.zip",
            "sha256": "69c32671349665ec4af9b8ab7a312e870b8318bf747041c0da2b8f505ce0e2e5",
        },
        {
            "os": "windows",
            "arch": "arm64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_windows_arm64.zip",
            "sha256": "c8ba01b8914da74bedbca653846c0311dcc2ed07fdb83bebacc59ba0f72c3f7e",
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

def cue_register_toolchains(version = "0.9.2"):
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

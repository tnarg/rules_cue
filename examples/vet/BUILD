load("@com_github_tnarg_rules_cue//cue:cue.bzl", "cue_vet_test")

cue_vet_test(
    name = "test_hello",
    srcs = ["hello.yaml"],
    schema = "schema.cue",
    schema_expr = "#Def",
    deps = [
        "//examples/lang:cue_de_library",
        "//examples/lang:cue_en_library",
    ],
)

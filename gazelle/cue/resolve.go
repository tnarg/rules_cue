package cuelang

import (
	"fmt"
	"log"
	"path"
	"sort"
	"strings"

	"github.com/bazelbuild/bazel-gazelle/config"
	"github.com/bazelbuild/bazel-gazelle/label"
	"github.com/bazelbuild/bazel-gazelle/pathtools"
	"github.com/bazelbuild/bazel-gazelle/repo"
	"github.com/bazelbuild/bazel-gazelle/resolve"
	"github.com/bazelbuild/bazel-gazelle/rule"
)

// Imports returns a list of ImportSpecs that can be used to import
// the rule r. This is used to populate RuleIndex.
//
// If nil is returned, the rule will not be indexed. If any non-nil
// slice is returned, including an empty slice, the rule will be
// indexed.
func (cl *cueLang) Imports(c *config.Config, r *rule.Rule, f *rule.File) []resolve.ImportSpec {
	switch r.Kind() {
	case "cue_library":
		return []resolve.ImportSpec{
			resolve.ImportSpec{
				Lang: cueName,
				Imp:  r.AttrString("importpath"),
			},
		}
	}
	return nil
}

// Embeds returns a list of labels of rules that the given rule
// embeds. If a rule is embedded by another importable rule of the
// same language, only the embedding rule will be indexed. The
// embedding rule will inherit the imports of the embedded rule.
func (cl *cueLang) Embeds(r *rule.Rule, from label.Label) []label.Label {
	// Cue doesn't have a concept of embedding as far as I know.
	return nil
}

// Resolve translates imported libraries for a given rule into Bazel
// dependencies. A list of imported libraries is typically stored in a
// private attribute of the rule when it's generated (this interface
// doesn't dictate how that is stored or represented). Resolve
// generates a "deps" attribute (or the appropriate language-specific
// equivalent) for each import according to language-specific rules
// and heuristics.
func (cl *cueLang) Resolve(c *config.Config, ix *resolve.RuleIndex, rc *repo.RemoteCache, r *rule.Rule, importsRaw interface{}, from label.Label) {
	if importsRaw == nil {
		return
	}
	imports := importsRaw.([]string)
	r.DelAttr("deps")
	depSet := make(map[string]bool)
	for _, imp := range imports {
		if _, ok := stdlib[imp]; ok {
			continue
		}

		res := ix.FindRulesByImport(
			resolve.ImportSpec{
				Lang: cueName,
				Imp:  imp,
			}, cueName)
		if len(res) > 0 {
			for _, entry := range res {
				l := entry.Label.Rel(from.Repo, from.Pkg)
				depSet[l.String()] = true
			}
		} else {
			prefix, repo, err := rc.Root(imp)
			if err != nil {
				log.Printf("error resolving %q: %+v", imp, err)
			} else {
				var pkg string
				if pathtools.HasPrefix(imp, prefix) {
					pkg = pathtools.TrimPrefix(imp, prefix)
				}
				if pkg != "" {
					base := path.Base(pkg)
					baseParts := strings.SplitN(base, ":", 2)
					var cuePkg string
					if len(baseParts) > 1 {
						cuePkg = baseParts[1]
					} else {
						cuePkg = base
					}
					l := label.New(repo, path.Join(path.Dir(pkg), baseParts[0]), fmt.Sprintf("cue_%s_library", cuePkg))
					depSet[l.String()] = true
				}
			}
		}
	}
	if len(depSet) > 0 {
		deps := make([]string, 0, len(depSet))
		for dep := range depSet {
			deps = append(deps, dep)
		}
		sort.Strings(deps)
		r.SetAttr("deps", deps)
	}
}

var stdlib = map[string]bool{
	"crypto/md5":      true,
	"crypto/sha1":     true,
	"crypto/sha256":   true,
	"crypto/sha512":   true,
	"encoding/base64": true,
	"encoding/csv":    true,
	"encoding/hex":    true,
	"encoding/json":   true,
	"encoding/yaml":   true,
	"html":            true,
	"list":            true,
	"math":            true,
	"math/bits":       true,
	"net":             true,
	"path":            true,
	"regexp":          true,
	"strconv":         true,
	"strings":         true,
	"struct":          true,
	"text/tabwriter":  true,
	"text/template":   true,
	"time":            true,
	"tool":            true,
	"tool/cli":        true,
	"tool/exec":       true,
	"tool/file":       true,
	"tool/http":       true,
	"tool/os":         true,
}

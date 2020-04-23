package cuelang

import (
	"log"
	"path"
	"path/filepath"
	"sort"
	"strings"

	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/parser"
	"github.com/bazelbuild/bazel-gazelle/config"
	"github.com/bazelbuild/bazel-gazelle/language"
	"github.com/bazelbuild/bazel-gazelle/rule"
	"github.com/iancoleman/strcase"
)

const (
	cueDefaultLibrary = "cue_default_library"
)

// GenerateRules extracts build metadata from source files in a
// directory.  GenerateRules is called in each directory where an
// update is requested in depth-first post-order.
//
// args contains the arguments for GenerateRules. This is passed as a
// struct to avoid breaking implementations in the future when new
// fields are added.
//
// empty is a list of empty rules that may be deleted after merge.
//
// gen is a list of generated rules that may be updated or added.
//
// Any non-fatal errors this function encounters should be logged
// using log.Print.
func (cl *cueLang) GenerateRules(args language.GenerateArgs) language.GenerateResult {
	cueFiles := make(map[string]*ast.File)
	for _, f := range append(args.RegularFiles, args.GenFiles...) {
		// Only generate Cue entries for cue files (.cue)
		if !strings.HasSuffix(f, ".cue") {
			continue
		}

		pth := filepath.Join(args.Dir, f)
		cueFile, err := parser.ParseFile(pth, nil)
		if err != nil {
			log.Printf("parsing cue file: path=%q, err=%+v", pth, err)
			continue
		}
		cueFiles[f] = cueFile
	}

	expectedPkgName := path.Base(args.Rel)

	// categorize cue files into export and library sources
	// cue_libary names are based on cue package name.
	var cueLibSrcs []string
	cueExpSrc := make(map[string]string)
	cueImports := make(map[string][]string)

	for fname, cueFile := range cueFiles {
		var target string
		pkg := cueFile.PackageName()
		if pkg == "" {
			target = binName(fname)
			cueExpSrc[target] = fname
		} else if pkg == expectedPkgName {
			target = cueDefaultLibrary
			cueLibSrcs = append(cueLibSrcs, fname)
		} else {
			log.Printf("ignoring cue file: path=%q, pkg=%q", fname, pkg)
		}
		for _, imprt := range cueFile.Imports {
			imprt := strings.Trim(imprt.Path.Value, "\"")
			cueImports[target] = append(cueImports[target], imprt)
		}
	}

	var res language.GenerateResult
	if cueLibSrcs != nil {
		rule := rule.NewRule("cue_library", cueDefaultLibrary)
		rule.SetAttr("srcs", cueLibSrcs)
		rule.SetAttr("visibility", []string{"//visibility:public"})
		rule.SetAttr("importpath", computeImportPath(args))
		imprts := cueImports[cueDefaultLibrary]
		sort.Strings(imprts)
		rule.SetPrivateAttr(config.GazelleImportsKey, imprts)
		res.Gen = append(res.Gen, rule)
	}

	for tgt, src := range cueExpSrc {
		rule := rule.NewRule("cue_export", tgt)
		rule.SetAttr("src", src)
		rule.SetAttr("visibility", []string{"//visibility:public"})
		imprts := cueImports[tgt]
		sort.Strings(imprts)
		rule.SetPrivateAttr(config.GazelleImportsKey, imprts)
		res.Gen = append(res.Gen, rule)
	}

	res.Imports = make([]interface{}, len(res.Gen))
	for i, r := range res.Gen {
		res.Imports[i] = r.PrivateAttr(config.GazelleImportsKey)
	}

	res.Empty = generateEmpty(args.File, cueLibSrcs, cueExpSrc)

	return res
}

func computeImportPath(args language.GenerateArgs) string {
	c := args.Config
	var conf *cueConfig
	if raw, ok := c.Exts[cueName]; ok {
		conf = raw.(*cueConfig)
	} else {
		conf = &cueConfig{}
	}

	suffix, err := filepath.Rel(conf.prefixRel, args.Rel)
	if err != nil {
		log.Printf("Failed to compute importpath: rel=%q, prefixRel=%q, err=%+v", args.Rel, conf.prefixRel, err)
		return args.Rel
	}
	if suffix == "." {
		return conf.prefix
	}

	return filepath.Join(conf.prefix, suffix)
}

func binName(basename string) string {
	parts := strings.Split(basename, ".")
	return strcase.ToSnake(strings.Join(parts[:len(parts)-1], "_"))
}

func generateEmpty(f *rule.File, cueLibSrcs []string, cueExpSrc map[string]string) []*rule.Rule {
	if f == nil {
		return nil
	}
	var empty []*rule.Rule
	for _, r := range f.Rules {
		switch r.Kind() {
		case "cue_library":
			if r.Name() == cueDefaultLibrary && cueLibSrcs == nil {
				empty = append(empty, rule.NewRule("cue_library", r.Name()))
			}
		case "cue_export":
			if _, ok := cueExpSrc[r.Name()]; !ok {
				empty = append(empty, rule.NewRule("cue_export", r.Name()))
			}
		default:
			// ignore
		}
	}
	return empty
}

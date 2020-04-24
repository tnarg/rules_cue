package cuelang

import (
	"fmt"
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

	implicitPkgName := path.Base(args.Rel)
	baseImportPath := computeImportPath(args)

	// categorize cue files into export and library sources
	// cue_libary names are based on cue package name.
	libraries := make(map[string]*cueLibrary)
	exports := make(map[string]*cueExport)

	for fname, cueFile := range cueFiles {
		pkg := cueFile.PackageName()
		if pkg == "" {
			tgt := exportName(fname)
			export := &cueExport{
				Name:    tgt,
				Src:     fname,
				Imports: make(map[string]bool),
			}
			for _, imprt := range cueFile.Imports {
				imprt := strings.Trim(imprt.Path.Value, "\"")
				export.Imports[imprt] = true
			}
			exports[tgt] = export
		} else {
			tgt := fmt.Sprintf("cue_%s_library", pkg)
			lib, ok := libraries[tgt]
			if !ok {
				var importPath string
				if pkg == implicitPkgName {
					importPath = baseImportPath
				} else {
					importPath = fmt.Sprintf("%s:%s", baseImportPath, pkg)
				}
				lib = &cueLibrary{
					Name:       tgt,
					ImportPath: importPath,
					Imports:    make(map[string]bool),
				}
				libraries[tgt] = lib
			}
			lib.Srcs = append(lib.Srcs, fname)
			for _, imprt := range cueFile.Imports {
				imprt := strings.Trim(imprt.Path.Value, "\"")
				lib.Imports[imprt] = true
			}
		}
	}

	var res language.GenerateResult
	for _, library := range libraries {
		res.Gen = append(res.Gen, library.ToRule())
	}

	for _, export := range exports {
		res.Gen = append(res.Gen, export.ToRule())
	}

	res.Imports = make([]interface{}, len(res.Gen))
	for i, r := range res.Gen {
		res.Imports[i] = r.PrivateAttr(config.GazelleImportsKey)
	}

	res.Empty = generateEmpty(args.File, libraries, exports)

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

func exportName(basename string) string {
	parts := strings.Split(basename, ".")
	return strcase.ToSnake(strings.Join(parts[:len(parts)-1], "_"))
}

func generateEmpty(f *rule.File, libraries map[string]*cueLibrary, exports map[string]*cueExport) []*rule.Rule {
	if f == nil {
		return nil
	}
	var empty []*rule.Rule
	for _, r := range f.Rules {
		switch r.Kind() {
		case "cue_library":
			if _, ok := libraries[r.Name()]; !ok {
				empty = append(empty, rule.NewRule("cue_library", r.Name()))
			}
		case "cue_export":
			if _, ok := exports[r.Name()]; !ok {
				empty = append(empty, rule.NewRule("cue_export", r.Name()))
			}
		default:
			// ignore
		}
	}
	return empty
}

type cueLibrary struct {
	Name       string
	ImportPath string
	Srcs       []string
	Imports    map[string]bool
}

func (cl *cueLibrary) ToRule() *rule.Rule {
	rule := rule.NewRule("cue_library", cl.Name)
	sort.Strings(cl.Srcs)
	rule.SetAttr("srcs", cl.Srcs)
	rule.SetAttr("visibility", []string{"//visibility:public"})
	rule.SetAttr("importpath", cl.ImportPath)
	var imprts []string
	for imprt, _ := range cl.Imports {
		imprts = append(imprts, imprt)
	}
	sort.Strings(imprts)
	rule.SetPrivateAttr(config.GazelleImportsKey, imprts)
	return rule
}

type cueExport struct {
	Name    string
	Src     string
	Imports map[string]bool
}

func (ce *cueExport) ToRule() *rule.Rule {
	rule := rule.NewRule("cue_export", ce.Name)
	rule.SetAttr("src", ce.Src)
	rule.SetAttr("visibility", []string{"//visibility:public"})
	var imprts []string
	for imprt, _ := range ce.Imports {
		imprts = append(imprts, imprt)
	}
	sort.Strings(imprts)
	rule.SetPrivateAttr(config.GazelleImportsKey, imprts)
	return rule
}

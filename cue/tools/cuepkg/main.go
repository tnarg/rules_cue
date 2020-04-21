package main

import (
	"archive/zip"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path"
)

func main() {
	log.SetPrefix("CuePkg: ")
	log.SetFlags(0)

	if err := run(os.Args[1:]); err != nil {
		log.Fatal(err)
	}
}

func run(args []string) error {
	var manifestPath, outPath string
	flags := flag.NewFlagSet("cuepkg", flag.ContinueOnError)
	flags.StringVar(&manifestPath, "manifest", "", "name of json file listing files to include")
	flags.StringVar(&outPath, "out", "", "output file or directory")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if manifestPath == "" {
		return errors.New("-manifest not set")
	}
	if outPath == "" {
		return errors.New("-out not set")
	}

	manifest, err := readManifest(manifestPath)
	if err != nil {
		return err
	}

	return genPkg(manifest, outPath)
}

type Manifest struct {
	ImportPath string   `json:"importpath"`
	Srcs       []string `json:"srcs"`
}

func readManifest(path string) (*Manifest, error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("error reading manifest: %v", err)
	}
	var manifest Manifest
	if err := json.Unmarshal(data, &manifest); err != nil {
		return nil, fmt.Errorf("error unmarshalling manifest %s: %v", path, err)
	}
	return &manifest, nil
}

func genPkg(manifest *Manifest, outPath string) (err error) {
	w, err := os.Create(outPath)
	if err != nil {
		return err
	}
	defer func() {
		if e := w.Close(); err == nil && e != nil {
			err = fmt.Errorf("error closing archive %s: %v", outPath, e)
		}
	}()

	z := zip.NewWriter(w)

	for _, srcPath := range manifest.Srcs {
		src, err := os.Open(srcPath)
		if err != nil {
			return err
		}

		base := path.Base(srcPath)
		zpath := path.Join("pkg", manifest.ImportPath, base)

		dst, err := z.Create(zpath)
		if err != nil {
			src.Close()
			return err
		}
		if _, err := io.Copy(dst, src); err != nil {
			src.Close()
			return err
		}
		if err := src.Close(); err != nil {
			return err
		}
	}

	if err := z.Close(); err != nil {
		return fmt.Errorf("error constructing archive %s: %v", outPath, err)
	}
	return nil
}

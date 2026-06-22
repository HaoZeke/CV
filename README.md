# rgCV

[![Project Status: Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-blue.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

Personal CV in four variants from **one literate org-mode source** (`cv.org`).
Short variants are tangled out as preambles, LaTeX bodies, and thin drivers
under `build/`; the full academic CV is exported directly from the master.

| Variant | How it is produced | CI artifact |
|---------|-------------------|-------------|
| Full (academic, moderncv) | `cv.org` export → `build/full/cv.tex` | `RG_CV_Full.pdf` |
| Two-page | tangles → `build/twopage/{preamble,body,cv}.org` | `RG_CV_TwoPage.pdf` |
| One-page | tangles → `build/onepage/...` | `RG_CV_OnePage.pdf` |
| Three-page grant | tangles → `build/grant/...` | `RG_CV_Grant3Page.pdf` |

Edit **only** [`cv.org`](cv.org). Facts and layout blocks for short variants live
under the `* Short variants` tree at the end of that file.

## Building

Requires [pixi](https://pixi.sh) and TeX Live with XeLaTeX + Biber.

```
pixi run all        # tangle, export, and compile every variant
pixi run full       # full CV only
pixi run twopage    # two-page only
pixi run onepage    # one-page only
pixi run grant      # three-page grant CV only
pixi run tangle     # write build/ artifacts without compiling
pixi run clean      # remove build/ and aux files
```

Pipeline: `cv.org` → emacs (`scripts/org2tex.el`) tangles + exports → `build/<variant>/cv.tex` → latexmk (XeLaTeX + Biber) → PDF.

## Structure

```
cv.org               # single source of truth (edit here)
shared/              # fonts, class, bibliography, latexmkrc
  rgcv.cls           # unified class: fullcv | twopage | onepage
  rgcv-bib.sty       # bibliography setup (publist, author highlight)
  publications.bib
  Fonts/ Picture/
  .latexmkrc
scripts/
  org2tex.el         # tangle/export dispatcher
  org-cv/            # vendored moderncv headline transcoder
build/               # generated (gitignored)
  full/ twopage/ onepage/ grant/
Misc/                # non-build ancillary PDFs
```

`TEXINPUTS`/`BIBINPUTS` are set in `shared/.latexmkrc` for compiles run from
`build/<variant>/` (paths point at `../../shared/`).

## CI

GitHub Actions builds all variants on push to `main` and publishes PDFs to the
`pdfs` orphan branch.

## License

Template code: [GPL v3](http://www.gnu.org/licenses/gpl-3.0).
Content: [CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).

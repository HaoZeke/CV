# rgCV

[![Project Status: Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-blue.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

Personal CV in four variants, all built from org-mode literate sources using
shared LaTeX resources and build tooling.

| Variant | Source | Output |
|---------|--------|--------|
| Full (12-page academic) | `curriculum-vitae/literate_cv.org` | `RG_CV_Full.pdf` |
| Two-page | `twoPage/literate_twopage.org` | `RG_CV_TwoPage.pdf` |
| One-page | `onePage/literate_onepage.org` | `RG_CV_OnePage.pdf` |
| Three-page grant CV | `cv3pageGrant/literate_cv3pageGrant.org` | `RG_CV_Grant3Page.pdf` |

## Building

Requires [pixi](https://pixi.sh) and a TeX Live installation with XeLaTeX + Biber.

```
pixi run all        # build all variants
pixi run mkpdf-full # build only the full CV
pixi run mkpdf-cv3pagegrant # build only the three-page grant CV
pixi run clean      # remove build artifacts
```

The build pipeline is: org -> emacs batch export -> `.tex` -> latexmk (XeLaTeX + Biber) -> PDF.

## Structure

```
shared/              # shared resources (fonts, class, bibliography)
  rgcv.cls           # unified class: fullcv | twopage | onepage modes
  rgcv-bib.sty       # bibliography setup (publist, author highlighting)
  publist.{bbx,cbx,dbx}  # biblatex-publist backend
  publications.bib   # single bibliography source
  Fonts/             # Minion Pro, Myriad Pro, FontAwesome, Literata
  Picture/           # headshot
  .latexmkrc         # shared latexmk config (symlinked by each variant)
scripts/
  org2tex.el         # emacs batch exporter (registers org-latex classes)
curriculum-vitae/    # full CV (moderncv-based)
cv3pageGrant/        # three-page grant-focused CV
twoPage/             # two-page concise CV
onePage/             # one-page highlight CV
```

Each variant directory contains an org source, a tangled preamble `.tex`, and a
symlinked `.latexmkrc`. All shared resources (fonts, bibliography, photo, class
files) live in `shared/` and are found via `TEXINPUTS`/`BIBINPUTS`.

## CI

GitHub Actions builds all variants on push to `main` and publishes PDFs to the
`pdfs` orphan branch.

## License

Template code: [GPL v3](http://www.gnu.org/licenses/gpl-3.0).
Content: [CC BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/).

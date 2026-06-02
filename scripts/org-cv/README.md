# Vendored org-cv

These files are vendored from [org-cv](https://gitlab.com/Titan-C/org-cv)
by Oscar Najera, licensed GPLv3 (license headers retained in each file).

- `org-cv-utils.el`
- `ox-moderncv.el`

Pinned to upstream commit `e8de952df7669b38ca475d00fe943ab96d8cfac4`.

`scripts/org2tex.el` adds this directory to `load-path` and derives a
`rgcv-latex` export backend that reuses `org-moderncv-headline`, so headlines
carrying `:CV_ENV: cventry` export as moderncv `\cventry` while the plain
`latex` template (and `preamble.tex`) is kept intact. Without this, those
headlines collapse to `\subsection` and the date/employer/role columns vanish.

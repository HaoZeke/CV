;; org2tex.el -- batch org-to-LaTeX exporter for rgCV
;; Usage: emacs --batch -l org2tex.el <orgfile>
;; or:    emacs -nl --script org2tex.el <orgfile>
(package-initialize)
(require 'ox)
(require 'ox-latex)
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))

;; Suppress org defaults
(setq org-latex-packages-alist 'nil)
(setq org-latex-with-hyperref 'nil)
(setq org-latex-hyperref-template 'nil)
(setq org-latex-minted-options 'nil)
(setq org-latex-listings 'listings)

;; Register rgcv classes for org export
(add-to-list 'org-latex-classes
  '("rgcv-full"
    "\\documentclass[fullcv]{rgcv}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
  '("rgcv-twopage"
    "\\documentclass[twopage]{rgcv}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")))

(add-to-list 'org-latex-classes
  '("rgcv-onepage"
    "\\documentclass[onepage]{rgcv}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")))

;; Also keep the legacy deedy-resume class for backward compat
(add-to-list 'org-latex-classes
  '("deedy-resume"
    "\\documentclass[letterpaper]{deedy-resume}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")))

;; Also keep moderncv
(add-to-list 'org-latex-classes
  '("moderncv"
    "\\documentclass[10pt,a4paper,final,factor=1100,stretch=18,shrink=18]{moderncv}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")))

;; Export the file
(let ((org-file (car command-line-args-left)))
  (when org-file
    (find-file org-file)
    (org-babel-tangle)
    (org-latex-export-to-latex)))

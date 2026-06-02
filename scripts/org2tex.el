;; org2tex.el -- batch org-to-LaTeX exporter for rgCV
;; Usage: emacs --batch -l org2tex.el <orgfile>
;; or:    emacs -nl --script org2tex.el <orgfile>
(package-initialize)
(require 'ox)
(require 'ox-latex)

;; Vendored org-cv (https://gitlab.com/Titan-C/org-cv) so the moderncv
;; cventry transcoder is available without the personal Emacs config.
(add-to-list 'load-path
             (expand-file-name "org-cv"
                               (file-name-directory
                                (or load-file-name buffer-file-name "."))))
(require 'org-cv-utils)
(require 'ox-moderncv)

;; Derived backend: inherit the plain `latex' template (preamble.tex and the
;; custom title block stay exactly as authored) but override headline
;; transcoding so headlines carrying `:CV_ENV: cventry' render as moderncv
;; \cventry instead of collapsing to \subsection.
(org-export-define-derived-backend 'rgcv-latex 'latex
  :menu-entry '(?r "Export with rgcv (moderncv cventry)" nil)
  :translate-alist '((headline . org-moderncv-headline)))

;; Try loading ox-extra (org-contrib), fall back to inline implementation
(condition-case nil
    (progn
      (require 'ox-extra)
      (ox-extras-activate '(ignore-headlines)))
  (file-missing
   ;; Inline ignore-headlines from ox-extra (avoids org-contrib dependency).
   ;; Headlines tagged :ignore: have their heading removed but contents kept.
   (defun org2tex--ignore-headline (headline backend info)
     "Strip headline text for :ignore: tagged headings, keeping body."
     (when (member "ignore" (org-element-property :tags headline))
       (let ((contents (org-export-get-body headline info)))
         contents)))
   ;; Use a transcode filter: override headline transcoding
   (advice-add 'org-latex-headline :around
     (lambda (orig headline contents info)
       (if (member "ignore" (org-element-property :tags headline))
           (or contents "")
         (funcall orig headline contents info))))))

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

;; moderncv (NO-DEFAULT-PACKAGES to avoid conflicts)
(add-to-list 'org-latex-classes
  '("moderncv"
    "\\documentclass[10pt,a4paper,final,factor=1100,stretch=18,shrink=18]{moderncv}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")))

;; Export the file
(let ((org-file (car command-line-args-left)))
  (when org-file
    (find-file org-file)
    (org-babel-tangle)
    (org-export-to-file 'rgcv-latex (org-export-output-file-name ".tex"))))

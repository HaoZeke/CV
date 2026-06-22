;;; org2tex.el --- batch org-to-LaTeX exporter for rgCV -*- lexical-binding: t -*-
;; Usage:
;;   emacs -nl --script scripts/org2tex.el tangle          ; tangle cv.org only
;;   emacs -nl --script scripts/org2tex.el full            ; tangle + export full CV
;;   emacs -nl --script scripts/org2tex.el twopage|onepage|grant
;;   emacs -nl --script scripts/org2tex.el all             ; tangle + export all
;;   emacs -nl --script scripts/org2tex.el <path/to/file.org>  ; legacy: single file
(package-initialize)
(require 'ox)
(require 'ox-latex)

(defvar rgcv-root
  (expand-file-name ".." (file-name-directory
                          (or load-file-name buffer-file-name ".")))
  "Repository root (parent of scripts/).")

(defvar rgcv-master
  (expand-file-name "cv.org" rgcv-root)
  "Single source of truth.")

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
   ;; Headlines tagged :ignore: have their heading removed but contents kept.
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

;; Allow tangling/export without interactive confirmation
(setq org-confirm-babel-evaluate nil)

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

;; article (grant variant)
(add-to-list 'org-latex-classes
  '("article"
    "\\documentclass[10pt,a4paper]{article}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(defun rgcv--tangle-master ()
  "Tangle cv.org into build/ (preambles, bodies, short-variant drivers)."
  (find-file rgcv-master)
  (org-babel-tangle)
  (message "Tangled %s" rgcv-master))

(defun rgcv--export-org (org-file tex-file)
  "Export ORG-FILE with rgcv-latex backend to TEX-FILE."
  (let ((default-directory (file-name-directory (expand-file-name org-file))))
    (find-file org-file)
    (org-export-to-file 'rgcv-latex tex-file)
    (message "Exported %s -> %s" org-file tex-file)))

(defun rgcv--export-full ()
  "Tangle master then export full CV into build/full/cv.tex."
  (rgcv--tangle-master)
  (let* ((build-dir (expand-file-name "build/full" rgcv-root))
         (tex-file (expand-file-name "cv.tex" build-dir)))
    (make-directory build-dir t)
    (rgcv--export-org rgcv-master tex-file)))

(defun rgcv--export-variant (variant)
  "Export a short variant (twopage|onepage|grant) from its tangled driver."
  (rgcv--tangle-master)
  (let* ((build-dir (expand-file-name (format "build/%s" variant) rgcv-root))
         (org-file (expand-file-name "cv.org" build-dir))
         (tex-file (expand-file-name "cv.tex" build-dir)))
    (unless (file-exists-p org-file)
      (error "Missing tangled driver %s; run tangle first" org-file))
    (rgcv--export-org org-file tex-file)))

(defun rgcv--dispatch (cmd)
  "Dispatch CMD: tangle, full, twopage, onepage, grant, all, or a path."
  (cond
   ((string= cmd "tangle") (rgcv--tangle-master))
   ((string= cmd "full") (rgcv--export-full))
   ((member cmd '("twopage" "onepage" "grant"))
    (rgcv--export-variant cmd))
   ((string= cmd "all")
    (rgcv--export-full)
    (dolist (v '("twopage" "onepage" "grant"))
      (rgcv--export-variant v)))
   ;; Legacy: treat as path to an org file
   ((file-exists-p cmd)
    (find-file cmd)
    (org-babel-tangle)
    (org-export-to-file 'rgcv-latex (org-export-output-file-name ".tex")))
   (t (error "Unknown command: %s" cmd))))

(let ((cmd (or (car command-line-args-left) "tangle")))
  (rgcv--dispatch cmd))

(require 'org)
(require 'org-exp)
(require 'org-latex)
(setq org-export-latex-listings 'minted)
(setq org-export-latex-minted t)
(setq org-export-latex-minted-langs
      '((html         "rhtml")
        (emacs-lisp   "common-lisp")
        (cc           "c++")
        (cperl        "perl")
        (shell-script "bash")
        (caml         "ocaml")
        (feature      "cucumber")))
(setq org-latex-to-pdf-process 
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-export-html-style-extra
      (concat "\n<style type='text/css'>\n"
              (with-temp-buffer
                (insert-file-contents 
                 (or 
                  (getenv "STYLESHEET")
                  (error "No $STYLESHEET set")))
                (buffer-string))
              "\n</style>\n"))
(setq org-babel-load-languages 
      (quote ((emacs-lisp . t) (ruby . t) (sh . t))))
(setq org-confirm-babel-evaluate nil)
(setq org-export-htmlize-output-type (quote css))
(setq org-export-htmlized-org-css-url nil)
(add-to-list 'org-export-latex-classes
	     '("orgpress-report"
	       "\\documentclass{report}"
	       ("\\chapter{%s}" . "\\chapter*{%s}")
	       ("\\section{%s}" . "\\section*{%s}")
	       ("\\subsection{%s}" . "\\subsection*{%s}")
	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	       ("\\paragraph{%s}" . "\\paragraph*{%s}")))
(setq cover-file (or (getenv "PDF_COVER") "cover.pdf"))
(setq cover-file-opts (or (getenv "PDF_COVER_OPTS") "pages=1, noautoscale=true"))
(when (and (stringp cover-file) 
           (not (string= cover-file ""))
           (file-exists-p cover-file))
  (setq org-export-latex-title-command
        (concat "\\includepdf["
                cover-file-opts
                "]{"
                cover-file
                "}")))

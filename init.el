(defun orgpress-env-file-contents (env-variable default)
  "If ENV-VARIABLE points to a file, return its contents. Otherwise return DEFAULT."
  (let ((filename (getenv env-variable)))
    (if (and (stringp filename) 
               (not (string= filename ""))
               (file-exists-p filename))
        (progn
          (with-temp-buffer
            (insert-file-contents filename)
            (buffer-string)))
      default)))

(defun orgpress-read-var (varname default)
  "If VARNAME is set, return the result of reading it. Otherwise return DEFAULT."
  (let ((value (getenv varname)))
    (if (and (stringp value) 
             (not (string= value "")))
        (read value)
      default)))

(defun orgpress-get-var (varname default)
  "If VARNAME is set, return the string value. Otherwise return DEFAULT."
  (let ((value (getenv varname)))
    (if (and (stringp value) 
             (not (string= value "")))
        value
      default)))


(require 'org)
(require 'org-exp)
(require 'org-latex)
(require 'org-html)
(require 'org-jsinfo)
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

(set-variable 'org-export-html-preamble
              (orgpress-env-file-contents "HTML_PREAMBLE_FILE" 
                                          org-export-html-preamble))
(set-variable 'org-export-html-postamble
              (orgpress-env-file-contents "HTML_POSTAMBLE_FILE" 
                                          org-export-html-preamble))

(setcdr (assq 'sdepth org-infojs-options) 
        (orgpress-get-var "INFOJS_SECTION_DEPTH" "max"))

(setcdr (assq 'buttons org-infojs-options) 
        (orgpress-get-var "INFOJS_BUTTONS" "0"))

(setcdr (assq 'path org-infojs-options) 
        (orgpress-get-var "INFOJS_PATH" "http://orgmode.org/org-info.js"))



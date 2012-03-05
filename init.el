(setq org-export-latex-listings 'minted)
(setq org-export-latex-minted t)
(setq org-export-latex-minted-langs
      '((html         "rhtml")
        (emacs-lisp   "common-lisp")
        (cc           "c++")
        (cperl        "perl")
        (shell-script "bash")
        (caml         "ocaml")))
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

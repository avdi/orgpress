(setq org-export-html-style-extra
      (concat "<style type='text/css'>\n"
              (with-temp-buffer
                (insert-file-contents 
                 (or 
                  (getenv "STYLESHEET")
                  ("No $STYLESHEET set")))
                (buffer-string))
              "\n</style>"))

(setq org-export-html-style-extra
      (concat "\n<style type='text/css'>\n"
              (with-temp-buffer
                (insert-file-contents 
                 (or 
                  (getenv "STYLESHEET")
                  (error "No $STYLESHEET set")))
                (buffer-string))
              "\n</style>\n"))

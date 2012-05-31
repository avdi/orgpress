$(OP_BOOK_NAME).$(EXPORT_FORMAT_EXTENSION): $(OP_BOOK_NAME).master
	$(emacs_export_command)

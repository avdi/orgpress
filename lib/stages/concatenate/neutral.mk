outputs		= $(OP_BOOK_NAME).monolith

$(OP_BOOK_NAME).monolith: $(OP_SIGNATURE_NAMES:%=%.org)
	cat $^ > $@

outputs				= $(OP_BOOK_NAME).zip
OP_BUNDLE_FORMATS		= .mobi .epub .pdf .html.zip .txt
OP_BUNDLE_FILES			= $(addprefix $(OP_BOOK_NAME),$(OP_BUNDLE_FORMATS))
CALC_VPATH_FLAGS		+= --all-platforms


################################################################################
# RULES
################################################################################
$(OP_BOOK_NAME).zip: $(OP_BUNDLE_FILES)
	$(ZIP) $(ZIPFLAGS) $@ -j $^

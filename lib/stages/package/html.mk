################################################################################
# VARIABLES
################################################################################
outputs			= $(OP_BOOK_NAME).html.zip

################################################################################
# RULES
################################################################################
%.html.zip: %.html $(LOCAL_ASSET_TARGETS) $(COMPOSITE_STYLESHEET)
	$(ZIP) $(ZIPFLAGS) $@ -j $<
	$(ZIP) $(ZIPFLAGS) $@ -j $(COMPOSITE_STYLESHEET)
	$(ZIP) $(ZIPFLAGS) $@ $(ASSET_TARGETS)
	$(ADD_FONTS_TO_ARCHIVE)


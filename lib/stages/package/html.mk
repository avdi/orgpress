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
	if [ -n "$(ASSET_TARGETS)" ]; then \
		$(ZIP) $(ZIPFLAGS) $@ $(ASSET_TARGETS); \
	fi
	$(ADD_FONTS_TO_ARCHIVE)


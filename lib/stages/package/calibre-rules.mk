# Getting set up for the conversion to ebook format is a bit
# involved. The source HTML and the other assets which will go into
# the finished product all need to be in the same directory together,
# so that e.g. IMG links can be resolved correctly. So before
# building, we need to make sure all the needed files (including
# subdirectories) are collected into the current build dir.
#
# Also, while Calibre handles the actual inclusion of inline images
# into the .epub file automatically based on the IMG tags found in the
# source file, we still need to inform Make about the dependency on
# those files. Right now we do that by just making the file depend on
# ALL declared assets. In future we'll probably compile a list of the
# actual image files that are linked to, during the extract-objects
# step.
#
# Finally, Calibre isn't smart enough to automatically include
# referenced font files. So we add them to the .epub file after the
# fact using zip.

%.epub %.mobi: %.html $(FONT_FILES) $(COMPOSITE_STYLESHEET) $(LOCAL_ASSET_TARGETS)
	cp -u -p -l $< $(@D)
	$(CONVERT) $(<F) $@ $(strip $(CONVERTFLAGS))
	$(POSTPROCESS_CALIBRE_OUTPUT)

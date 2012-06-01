# Getting set up for the conversion to ebook format is a bit
# involved. The source HTML and the other assets which will go into
# the finished product all need to be in the same directory together,
# so that e.g. IMG links can be resolved correctly. So before
# building, we need to make sure all the needed files (including
# subdirectories) are collected into the current build dir.
%.epub %.mobi: %.html $(SOURCE_ASSETS)
	cp -u -p -l $< $(@D)
	for root in $(wildcard $(ASSET_ROOTS)); do \
	  $$(cd $${root}; cp -u -p -r -l --parents $(OP_ASSETS) $(abspath $(@D))); \
	done 
	$(CONVERT) $(<F) $@ $(strip $(CONVERTFLAGS))


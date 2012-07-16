.PHONY: copy_assets

op-listings-stylesheet.css: PYG_STYLES_CMD=pygmentize -S colorful -f html
op-listings-stylesheet.css:
	echo '/* Pygments generated styles ($(PYG_STYLES_CMD)) */' > $@
	$(PYG_STYLES_CMD) >> $@
	echo '/* END Pygments generated styles ($(PYG_STYLES_CMD)) */' >> $@

op-composite-stylesheet.css: $(SYSTEM_STYLESHEETS) $(LISTINGS_STYLESHEETS) $(FONT_STYLESHEETS) $(STYLESHEETS)
	cat $^ > $@

# copy_assets:
# 	for root in $(wildcard $(ASSET_ROOTS)); do \
# 	  $$(cd $${root}; cp -u -p -r -l --parents $(OP_ASSETS) $(abspath $(@D))); \
# 	done 

# Generate dependency rules for every concrete asset found
$(foreach target,$(LOCAL_ASSET_TARGETS),$(call DECLARE_ASSET_DEP,$(target)))

# A rule for copying the assets into the local
# stage/platform-speecific build dir
$(LOCAL_ASSET_TARGETS):
	mkdir -p $(@D)
	cp -lfup $< $@

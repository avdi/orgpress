################################################################################
# VARIABLES
################################################################################

OP_DIST_FILES		= $(OP_BOOK_NAME).zip
OP_HOOK_DIR		= $(abspath $(OP_BOOK_DIR)/.orgpress/hooks)
OP_DIST_HOOK_DIR	= $(abspath $(OP_HOOK_DIR)/distribute)
OP_DIST_HOOKS		= $(wildcard $(OP_DIST_HOOK_DIR)/*)
dist_hook_names		= $(notdir $(OP_DIST_HOOKS))
dist_hook_stampfiles    = $(addsuffix .dist-timestamp,$(dist_hook_names))
outputs			= $(dist_hook_stampfiles)

################################################################################
# FUNCTIONS
################################################################################

# $(call run_hook,<hook filename>,<timestamp filename>,<dist filename...>)
define run_hook
if [ -x $1 ]; then
	$1 $3 && touch $2;
fi
endef

################################################################################
# RULES
################################################################################

%.dist-timestamp: hook_file=$(OP_DIST_HOOK_DIR)/$*
%.dist-timestamp: $(OP_DIST_FILES)
	$(strip $(call run_hook,$(hook_file),$@,$^))

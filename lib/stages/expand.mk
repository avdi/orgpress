################################################################################
# TOOLS
################################################################################

# Macro processor
M4			= m4
M4_INIT_FILE		= $(abspath $(OP_LIB_DIR)/init.m4)
M4FLAGS			= --prefix-builtins $(M4_INIT_FILE) $(expand_defs)

################################################################################
# VARIABLES
################################################################################
outputs			= $(OP_BOOK_NAME).master

# Create separate files for each platform
CALC_VPATH_FLAGS	+= --no-include-current

expand_vars		= OP_STAGE OP_PLATFORM OP_TITLE OP_AUTHOR OP_REVISION \
                          OP_PUBYEAR OP_FORMAT

define expand_defs
$(strip $(foreach varname,$(strip $(expand_vars)),-D $(varname)="$($(varname))"))
endef

################################################################################
# RULES
################################################################################

$(OP_BOOK_NAME).master: $(OP_BOOK_NAME).template
	$(M4) $(M4FLAGS) $(master_defs) $< > $@

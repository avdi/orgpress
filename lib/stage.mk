################################################################################
# TOOLS
################################################################################

# A tool for calculating search paths across stages
CALC_VPATH		= $(OP_ROOT)/bin/calc_vpath
CALC_VPATH_FLAGS	= 

# Awk! Awk! Awk!
AWK			= gawk
AWKFLAGS		= 

################################################################################
# FUNCTIONS
################################################################################

# $(call stage_platform_vpath,<STAGE>,<PLATFORM>)
define stage_platform_vpath
$(shell $(CALC_VPATH) $(CALC_VPATH_FLAGS) $(OP_BOOK_DIR) $1 $2 $(OP_STAGES))
endef

################################################################################
# STAGE-SPECIFIC IMPLEMENTATION
################################################################################

-include $(OP_LIB_DIR)/stages/$(OP_STAGE).mk
-include $(OP_LIB_DIR)/platforms/$(OP_PLATFORM).mk
-include $(OP_LIB_DIR)/stages/$(OP_STAGE)/$(OP_PLATFORM).mk

################################################################################
# SETUP
################################################################################

# VPATH is a special variable which determines the search path for prerequisites
VPATH		= $(call stage_platform_vpath,$(OP_STAGE),$(OP_PLATFORM))

################################################################################
# RULES
################################################################################

.PHONY: default

ifndef outputs
	$(info No outputs defined for $(OP_STAGE)/$(OP_PLATFORM))
endif

default: $(outputs)


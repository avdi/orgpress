################################################################################
# TOOLS
################################################################################

# Awk! Awk! Awk!
AWK			= gawk
AWKFLAGS		= 

################################################################################
# STAGE-SPECIFIC IMPLEMENTATION
################################################################################

-include $(OP_LIB_DIR)/stages/$(OP_STAGE).mk
-include $(OP_LIB_DIR)/platforms/$(OP_PLATFORM).mk
-include $(OP_LIB_DIR)/stages/$(OP_STAGE)/$(OP_PLATFORM).mk

################################################################################
# RULES
################################################################################

.PHONY: default

ifndef outputs
	$(info No outputs defined for $(OP_STAGE)/$(OP_PLATFORM))
endif

default: $(outputs)


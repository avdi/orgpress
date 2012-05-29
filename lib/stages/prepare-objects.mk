################################################################################
# SETUP
################################################################################

################################################################################
# VARIABLES
################################################################################
outputs			= MLISTINGS
preplisting_file	= $(abspath $(OP_ROOT)/bin/preplisting.awk)
preplisting		= $(AWK) $(AWKFLAGS) -f $(preplisting_file)
preplistingflags	= -vFLAVOR=html

################################################################################
# RULES
################################################################################
MLISTINGS: LISTINGS
	$(MAKE) -f $(OP_LIB_DIR)/stage.mk $(patsubst %.listing,%.mlisting,$(strip $(shell cat $<)))

%.mlisting: %.listing
	$(preplisting) $(preplistingflags) $< > $@


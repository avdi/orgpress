################################################################################
# VARIABLES
################################################################################

# Document converter extroardinaire
PANDOC			= ~/.cabal/bin/pandoc
PANDOCFLAGS		= 

outputs			= $(normalized_signatures)
normalized_signatures   = $(OP_SIGNATURE_NAMES:%=%.org)

################################################################################
# RULES
################################################################################

%.org: %.markdown
	$(PANDOC) $(PANDOCFLAGS) -o $@ $<






################################################################################
# VARIABLES
################################################################################

# Document converter extroardinaire
PANDOC			= ~/.cabal/bin/pandoc
PANDOCFLAGS		= --to=org

# As of version 1.9.3 there is a bug in Pandoc's Org output which
# omits the space in between the BEGIN_SRC directive and the language
# name. This fix performs the following transformation:
#
#    '#+BEGIN_SRCruby' => '#+BEGIN_SRC ruby'
define fix_pandoc
sed -r 's/^([[:space:]]*#\+begin_src)([^[:space:]])/\1 \2/i'
endef

outputs			= $(normalized_signatures)
normalized_signatures   = $(OP_SIGNATURE_NAMES:%=%.org)

################################################################################
# RULES
################################################################################

%.org: %.markdown
	$(PANDOC) $(PANDOCFLAGS) $< | $(fix_pandoc) > $@






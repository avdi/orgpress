################################################################################
# TOOLS
################################################################################

WGET			= wget
WGETFLAGS		=

################################################################################
# FUNCTIONS
################################################################################

# $(call fetch_url,<URL>,<FILENAME>)
define fetch_url
cd $(OP_VENDOR_DIR) && $(WGET) $(WGETFLAGS) -O "$2" "$1"
endef

################################################################################
# VARIABLES
################################################################################
EXTRA_VPATH		= $(OP_VENDOR_DIR)

OP_PREREQUISITES	+=

INCONSOLATA_URL		= "http://levien.com/type/myfonts/Inconsolata.otf"
INCONSOLATA_LICENSE_URL = "http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=OFL_plaintext&filename=OFL.txt"

outputs			= $(OP_VENDOR_DIR) $(OP_PREREQUISITES)

################################################################################
# RULES
################################################################################
$(OP_VENDOR_DIR):
	mkdir -p $(OP_VENDOR_DIR)

font-inconsolata: Inconsolata.otf Inconsolata-LICENSE.txt

Inconsolata.otf:
	$(call fetch_url,$(INCONSOLATA_URL),$@)

Inconsolata-LICENSE.txt:
	$(call fetch_url,$(INCONSOLATA_LICENSE_URL),$@)

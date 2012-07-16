################################################################################
# TOOLS
################################################################################

ZIP			= zip
ZIPFLAGS		=

################################################################################
# VARIABLES
################################################################################

# Stylesheets that are part of (or created by) OrgPress
SYSTEM_STYLESHEETS		= op-neutral-stylesheet.css

# Project stylesheets. Defaults to every *.css file.
STYLESHEETS			= $(call find_files,'*.css')

# Where to look for asset files, in order from least specific to most specific.
ASSET_ROOTS			= $(strip $(OP_VENDOR_DIR) \
				          $(OP_BOOK_DIR) \
				          $(OP_BOOK_DIR)/$(OP_PLATFORM))

# Possible font file extensions
FONT_EXTS			= ttf otf eot woff svg

# All font files found in the project. Fonts are expected to be in
# subdirectories of fonts/ or <PLATFORM>/fonts, e.g.:
#
# - fonts/inconsolata/inconsolata.ttf
# - fonts/epub/DroidSansMono/DroidSansMono.otf
#
# This is consistent with FontSquirrel fontpacks.
define FONT_FILES
$(strip $(foreach root,
                  $(ASSET_ROOTS),
                  $(wildcard $(addprefix $(root)/fonts/*/*.,$(FONT_EXTS)))))
endef

# Relative paths to the found font files.
define RELATIVE_FONT_FILES
$(strip $(foreach root,
                  $(ASSET_ROOTS),
                  $(patsubst $(root)/%,
                             %,
                             $(wildcard $(addprefix $(root)/fonts/*/*.,
                                                    $(FONT_EXTS))))))
endef

# Stylesheets which contain @font-face directives, or any other
# font-specific rules. These are expected to be found in a file named
# fonts/<FONTNAME>/stylesheet.css in either the project root or in a
# platform-specific subdirectory. This is consistent with FontSquirrel
# fontpacks.
define FONT_STYLESHEETS
$(addsuffix stylesheet.css,$(dir $(RELATIVE_FONT_FILES)))
endef

# A list of real path names to asset files, derived by expanding the
# asset wildcard patterns in OP_ASSETS against every asset root.
define ASSET_SOURCES
$(strip $(foreach root,
                  $(ASSET_ROOTS),
                  $(wildcard $(addprefix $(root)/,$(OP_ASSETS)))))
endef

# The root-independent versions of asset filenames, sorted and with
# duplicates removed (this is a side effect ot sorting). So if the
# ASSET_SOURCES include:
#
# - /proj_root/images/bar.jpg 
# - /proj_root/images/foo.jpg 
# - /proj_root/images/kindle/foo.jpg
#
# Then the resulting targets will be:
#
# - images/bar.jpg
# - images/foo.jpg
define ASSET_TARGETS
$(strip $(sort $(foreach root,
                         $(ASSET_ROOTS),
                         $(subst $(root)/,,$(wildcard $(addprefix $(root)/,$(OP_ASSETS)))))))
endef

# Absolute filenames of the asset files once they are copied into the
# current directory. E.g.:
#
# - /proj_root/build/package/epub/images/bar.jpg
# - /proj_root/build/package/epub/images/foo.jpg
LOCAL_ASSET_TARGETS = $(addprefix $(CURDIR)/,$(ASSET_TARGETS))

define ADD_FONTS_TO_ARCHIVE
if [ -n "$(FONT_FILES)" ]; then $(ZIP) $(ZIPFLAGS) $@ -j $(FONT_FILES); fi
endef

################################################################################
# FUNCTIONS
################################################################################

# Find files in the preceding stages or project dir
# $(call find_files,<FILE_ GLOB>)
define find_files
$(shell $(strip $(CALC_VPATH) which --platform $(OP_PLATFORM) 
                                    --stage $(OP_STAGE) -a -r 
                                    --no-include-current '$1'))
endef

# Locate an asset in the asset roots, preferring the most specific to
# the least specific. So given the following assets:
#
# - /proj_root/images/bar.jpg 
# - /proj_root/images/foo.jpg 
# - /proj_root/images/kindle/foo.jpg
#
# $(call FIND_ASSET,images/foo.jpg) will return:
#
# - /proj_root/images/kindle/foo.jpg if the current platform is kindle
# - /proj_root/images/foo.jpg for any other platform.
define FIND_ASSET
$(lastword $(strip $(wildcard $(addsuffix /$1,$(ASSET_ROOTS)))))
endef

# A template for declaring a rule, for use in ($eval ...)
#
# Note: The semicolon is important!
define DECLARE_ASSET_DEP
$1: $(call FIND_ASSET,$(patsubst $(CURDIR)/%,%,$1))
endef


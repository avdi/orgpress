################################################################################
# TOOLS
################################################################################

# A tool for calculating search paths across stages
CALC_VPATH		= $(OP_ROOT)/bin/calc_vpath
CALC_VPATH_FLAGS	= 

# Awk! Awk! Awk!
AWK			= gawk
AWKFLAGS		= 

ZIP			= zip
ZIPFLAGS		=

################################################################################
# GLOBAL VARIABLES
################################################################################

# Path to this file
OP_MAKEFILE		:= $(lastword $(MAKEFILE_LIST))

# The OrgPress root directory
export OP_ROOT		?= $(abspath $(dir $(OP_MAKEFILE))/..)

# The book project root directory
export OP_BOOK_DIR	?= $(abspath $(CURDIR))

# The root for all built files
export OP_BUILD_DIR 	?= $(abspath $(CURDIR)/build)

export OP_LIB_DIR	?= $(abspath $(OP_ROOT)/lib)

# The name (for file naming purposes) of the book being built
export OP_BOOK_NAME	?= $(notdir $(OP_BOOK_DIR))

# The book title
export OP_BOOK_TITLE	?= $(OP_BOOK_NAME)

export OP_SOURCES 	?= $(OP_BOOK_NAME).org

export OP_FRONTMATTER	?= $(OP_LIB_DIR)/basic-frontmatter.org

# The author, or authors
export OP_AUTHOR	?= Unknown Author

# The person or organization which produced the ebook file
export OP_PRODUCER	?= $(OP_AUTHOR)

# Misc. comments about the book
export OP_COMMENTS	?= $(OP_BOOK_TITLE) copyright (c) $(OP_PUBYEAR) $(OP_AUTHOR)

# The language of the book
export OP_LANGUAGE	?= en-US

# The book publisher
export OP_PUBLISHER	?= $(OP_AUTHOR)

# The publication date
export OP_PUBDATE	?= $(shell ls -ldc $(CURDIR) | cut -d' ' -f6)

# The revision number
export OP_BOOK_REVISION ?= 1

# The publication year
export OP_PUBYEAR	?= $(firstword $(subst -, ,$(OP_PUBDATE)))

# Set default HTML stylesheet here because more than one platform uses
# it.
export OP_STYLESHEET	?= $(abspath $(OP_LIB_DIR)/styles.css)


################################################################################
# INTERNAL VARIABLES
################################################################################

# Format is a somewhat broader version of "platform", identifying the
# initial target file format. Several platforms may share a single
# format; e.g. html, web, and epub platforms might all have a format
# of "html".
export OP_FORMAT	= $(OP_PLATFORM)

# Directory for third-party files
OP_VENDOR_DIR		?= $(OP_BOOK_DIR)/vendor

# A master stylesheet formed from the concatenation of all system and
# project stylesheets.
COMPOSITE_STYLESHEET	= op-composite-stylesheet.css

# We use the bookbinding meaning of "signature", to mean "a section
# that contains text".
export OP_SIGNATURE_NAMES ?= $(basename $(OP_FRONTMATTER)) \
			     $(basename $(OP_SOURCES))     \
                             $(basename $(OP_BACKMATTER))

################################################################################
# FUNCTIONS
################################################################################

# $(call stage_platform_vpath,<STAGE>,<PLATFORM>)
define stage_platform_vpath
$(shell $(CALC_VPATH) $(CALC_VPATH_FLAGS) --book-dir $(OP_BOOK_DIR) --stage $1 --platform $2)
endef

################################################################################
# SETUP
################################################################################

# VPATH is a special variable which determines the search path for prerequisites
VPATH		= $(call stage_platform_vpath,$(OP_STAGE),$(OP_PLATFORM))

################################################################################
# STAGE-SPECIFIC IMPLEMENTATION
################################################################################

# First, load definitions that apply for the platform at any stage
-include $(OP_LIB_DIR)/platforms/$(OP_PLATFORM).mk

# Next, definitions that apply to the stage, independent of platform
-include $(OP_LIB_DIR)/stages/$(OP_STAGE).mk

# Next, definitions that apply to only this combination of stage and platform
-include $(OP_LIB_DIR)/stages/$(OP_STAGE)/$(OP_PLATFORM).mk

# Sometimes rules need to be deferred until ALL variable definitions
# have been made.
-include $(OP_LIB_DIR)/stages/$(OP_STAGE)/rules.mk

# ...and some rules are platform-specific
-include $(OP_LIB_DIR)/stages/$(OP_STAGE)/$(OP_PLATFORM)/rules.mk

################################################################################
# RULES
################################################################################

.PHONY: default

ifndef outputs
	$(info No outputs defined for $(OP_STAGE)/$(OP_PLATFORM))
endif

default: $(outputs)

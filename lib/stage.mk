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
# GLOBAL VARIABLES
################################################################################

# The book title
export OP_BOOK_TITLE	?= $(OP_BOOK_NAME)

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

################################################################################
# FUNCTIONS
################################################################################

# $(call stage_platform_vpath,<STAGE>,<PLATFORM>)
define stage_platform_vpath
$(shell $(CALC_VPATH) $(CALC_VPATH_FLAGS) --book-dir $(OP_BOOK_DIR) --stage $1 --platform $2)
endef

################################################################################
# STAGE-SPECIFIC IMPLEMENTATION
################################################################################

-include $(OP_LIB_DIR)/platforms/$(OP_PLATFORM).mk
-include $(OP_LIB_DIR)/stages/$(OP_STAGE).mk
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

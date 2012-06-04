# Some common definitions for formats that use Calibre for conversion

################################################################################
# VARIABLES
################################################################################

CALIBRE_STYLESHEET		= $(OP_LIB_DIR)/calibre.css

SYSTEM_STYLESHEETS		+= $(CALIBRE_STYLESHEET)

outputs				= $(OP_BOOK_NAME).$(CONVERT_FORMAT_EXTENSION)

################################################################################
# TOOLS
################################################################################

# The Calibre conversion command
CONVERT			= ebook-convert

# Flags for the Calibre conversion command
define CONVERTFLAGS
--authors "$(OP_AUTHOR)" --book-producer "$(OP_PRODUCER)"
--comments "$(OP_COMMENTS)"
--language "$(OP_LANGUAGE)" --publisher "$(OP_PUBLISHER)"
--pubdate "$(OP_PUBDATE)" --title "$(OP_BOOK_TITLE)"
--use-auto-toc --no-chapters-in-toc
--toc-threshold 0 --max-toc-links 0
--chapter "//h:div[@class='outline-2']/h:h2"
--level1-toc "//h:div[@class='outline-2']/h:h2" 
--level2-toc "//h:div[@class='outline-3']/h:h3" 
--level3-toc "//h:div[@class='outline-4']/h:h4" 
--extra-css $(COMPOSITE_STYLESHEET)
endef

################################################################################
# FUNCTIONS
################################################################################


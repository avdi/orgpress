ORGPRESS_VERSION	:= 0.0.1
ORGPRESS_MAKEFILE	:= $(lastword $(MAKEFILE_LIST))
ORGPRESS_ROOT		:= $(dir $(ORGPRESS_MAKEFILE))
MAKEFILES		:= $(ORGPRESS_MAKEFILE)

# Tools
EMACS			= $(shell which emacs)
EMACS_VERSION		= $(shell $(EMACS) --version | head -n1)
EMACS_INIT		= $(ORGPRESS_ROOT)/init.el
CONVERT			= ebook-convert
define CONVERTFLAGS
--authors "$(AUTHORS)" --book-producer "$(PRODUCER)"
--comments "$(COMMENTS)"
--language "$(LANGUAGE)" --publisher "$(PUBLISHER)"
--pubdate "$(PUBDATE)" --title "$(BOOK_TITLE)"
--use-auto-toc --no-chapters-in-toc
--toc-threshold 0 --max-toc-links 0
--chapter "//h:div[@class='outline-2']/h:h2"
--level1-toc "//h:div[@class='outline-2']/h:h2" 
--level2-toc "//h:div[@class='outline-3']/h:h3" 
--level3-toc "//h:div[@class='outline-4']/h:h4" 
--extra-css ".example { border: 1pt solid black; padding: 0.5ex; }"
endef
define EPUBFLAGS
--output-profile ipad  --preserve-cover-aspect-ratio
endef
# --cover "$(EPUBCOVER)"
define MOBIFLAGS
--output-profile kindle 
endef
# --cover "$(MOBICOVER)"
CALIBRE_INPUT		= $(call flavor_file,calibre.html)

# Book metadata
BOOK_NAME               = $(notdir $(CURDIR))
SOURCE_FILE		= $(BOOK_NAME).org
BOOK_TITLE		= $(BOOK_NAME)
AUTHORS			= Unknown Author
PRODUCER		= $(AUTHOR)
COMMENTS		= $(BOOK_TITLE)
LANGUAGE		= en-US
PUBLISHER		= $(AUTHORS)
PUBDATE			= $(shell ls -ldc $(CURDIR) | cut -d' ' -f6)

# Org export customizations
HEADLINE_LEVELS		:= 5
TABLE_OF_CONTENTS	:= nil
SECTION_NUMBERS		:= nil

# Misc setup
BUILD_DIR		:= $(CURDIR)/build
export STYLESHEET	= $(ORGPRESS_ROOT)/styles.css
ALL_FLAVORS		= epub mobi pdf html calibre.html
BUNDLE_FLAVORS		= epub mobi pdf html
CALIBRE_FLAVORS		= epub mobi
BUNDLE_FILES		= $(BUNDLE_FLAVORS:%=$(BUILD_DIR)/$(BOOK_NAME).%)
CALIBRE_OUTPUTS		= $(foreach flavor,$(CALIBRE_FLAVORS),$(call flavor_file,$(flavor)))

export_target		:= $(BUILD_DIR)/$(BOOK_NAME).$(FLAVOR)

# Functions
flavor_file		= $(BUILD_DIR)/$(BOOK_NAME).$(1)

define export_plist_calibre_elisp
:table-of-contents	$(TABLE_OF_CONTENTS)
:headline-levels	$(HEADLINE_LEVELS)
:section-numbers	$(SECTION_NUMBERS)
:language		$(LANGUAGE)
endef

define export_command_calibre_elisp
(progn
	(org-export-as-html 
		$(HEADLINE_LEVELS) 
		nil 
		(quote ($(export_plist_calibre_elisp))) 
		"*orgpress-export*")
	(with-current-buffer "*orgpress-export*"
		(write-file "$(export_target)")))
endef

$(info OrgPress version $(ORGPRESS_VERSION))

include $(CURDIR)/book.mk

$(info Building $(BOOK_NAME))
$(info Calibre outputs: $(CALIBRE_OUTPUTS))

default: $(BUNDLE_FLAVORS)

$(ALL_FLAVORS):
	$(MAKE) $(call flavor_file,$@)

$(CALIBRE_OUTPUTS): FLAVOR=$(subst .,,$(suffix $@))
$(CALIBRE_OUTPUTS): $(CALIBRE_INPUT) $(CURDIR)/book.mk $(ORGPRESS_MAKEFILE)
	$(CONVERT) $< $@ $(strip $(CONVERTFLAGS)) $(strip $($(FLAVOR)FLAGS))

$(export_target): $(EMACS_INIT) $(SOURCE_FILE)
	$(EMACS) $(EMACS_INIT:%=-l %) \
		--user $(USER) \
		--batch \
		--file $(SOURCE_FILE) \
		--eval '$(strip $(export_command_calibre_elisp))' \

$(BUILD_DIR):
	mkdir -p $@

ORGPRESS_VERSION	:= 0.0.1

# Path to this file
ORGPRESS_MAKEFILE	:= $(lastword $(MAKEFILE_LIST))

# Path to the book makefile, containing book-specific customizations
# to the rules and variables set up here.
BOOK_MAKEFILE		:= $(CURDIR)/book.mk

# The OrgPress root directory
ORGPRESS_ROOT		:= $(dir $(ORGPRESS_MAKEFILE))

# Tell make to load this file in recursive invocations
MAKEFILES		:= $(ORGPRESS_MAKEFILE)

### TOOLS ###

# Where to find Emacs
EMACS			= $(shell which emacs)

# The Emacs version
EMACS_VERSION		= $(shell $(EMACS) --version | head -n1)

# ELisp files which should be loaded when Emacs is invoked
EMACS_LOAD		= $(ORGPRESS_ROOT)/init.el

# Emacs command-line arguments
EMACSFLAGS		= 

# Command for viewing files
OPEN			= xdg-open

ifdef DEBUG
  EMACSFLAGS += --debug-init
endif

# The Calibre conversion command
CONVERT			= ebook-convert

# Flags for the Calibre conversion command
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

# Calibre flags specific to Epub
define EPUBFLAGS
--output-profile ipad  --preserve-cover-aspect-ratio
endef
# --cover "$(EPUBCOVER)"

# Calibre flags specific to Mobi
define MOBIFLAGS
--output-profile kindle 
endef
# --cover "$(MOBICOVER)"

# The input HTML file for Calibre conversions
CALIBRE_INPUT		= $(call flavor_file,calibre.html)

### BOOK METADATA ###

# The basename of the book, for use in filenames
BOOK_NAME               = $(notdir $(CURDIR))

# The main org-mode source file
SOURCE_FILE		= $(BOOK_NAME).org

# The book title
BOOK_TITLE		= $(BOOK_NAME)

# The author, or authors
AUTHORS			= Unknown Author

# The person or organization which produced the ebook file
PRODUCER		= $(AUTHORS)

# Misc. comments about the book
COMMENTS		= $(BOOK_TITLE)

# The language of the book
LANGUAGE		= en-US

# The book publisher
PUBLISHER		= $(AUTHORS)

# The publication date
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

# Extra files or directories that the book depends on, e.g. images
# ASSETS			= 

# Flavors which require Calibre conversion
CALIBRE_FLAVORS		= epub mobi

# File targets Calibre can produce
CALIBRE_TARGETS		= $(foreach flavor,$(CALIBRE_FLAVORS),$(call flavor_file,$(flavor)))

# Flavors Org exports directly
ORG_EXPORT_FLAVORS      = pdf html calibre.html

# File targets Org exports directly
ORG_EXPORT_TARGETS      = $(foreach flavor,$(ORG_EXPORT_FLAVORS),$(call flavor_file,$(flavor)))

# Files to bundle up in the deliverable
BUNDLE_FILES		= $(BUNDLE_FLAVORS:%=$(BUILD_DIR)/$(BOOK_NAME).%)

# Standard dependencies
STANDARD_DEPS		= $(ORGPRESS_MAKEFILE) $(BOOK_MAKEFILE) $(build_assets)

export_target		:= $(BUILD_DIR)/$(BOOK_NAME).$(FLAVOR)
skeleton		:= $(BUILD_DIR)/$(BOOK_NAME).org
skeleton_vars		:= BOOK_TITLE AUTHORS SOURCE_FILE
define skeleton_defs
$(strip $(foreach varname,$(skeleton_vars),-D ORGPRESS_$(varname)="$($(varname))"))
endef

### FUNCTIONS ###

# Given a flavor name (e.g. "mobi"), return the path of the
# corresponding output file
flavor_file		= $(BUILD_DIR)/$(BOOK_NAME).$(1)

# Convert a string to all-uppercase
uppercase		= $(shell echo $(1) | tr a-z A-Z)

define export_plist
:table-of-contents	$(TABLE_OF_CONTENTS)
:headline-levels	$(HEADLINE_LEVELS)
:section-numbers	$(SECTION_NUMBERS)
:language		$(LANGUAGE)
endef

define export_elisp
(progn
        (cd "$(CURDIR)")
	(org-export-as-$(FLAVOR) 
		$(HEADLINE_LEVELS) 
		nil 
		(quote ($(export_plist))) 
		"*orgpress-export*")
	(with-current-buffer "*orgpress-export*"
		(write-file "$@")))
endef


$(info OrgPress version $(ORGPRESS_VERSION))

ifdef DEBUG
  $(info Debug mode enabled)
  DEBUG_PRECIOUS_FILES = $(skeleton) 
endif 

include $(BOOK_MAKEFILE)

build_assets = $(patsubst %,$(BUILD_DIR)/%,$(wildcard $(ASSETS)))

$(info Building $(BOOK_NAME))

default: $(BUNDLE_FLAVORS)

info:

# This sets up shortcut targets for flavors, e.g.:
#   make epub
# Or:
#   make pdf
$(ALL_FLAVORS):
	$(MAKE) $(call flavor_file,$@)
	if [ -n "$(OPEN_TARGET)" ]; then $(OPEN) $(call flavor_file,$@); fi

%.pdf %.html %.txt %.mobi %.epub: FLAVOR = $(subst .,,$(suffix $@))

$(CALIBRE_TARGETS): flavorflags = $($(call uppercase,$(FLAVOR))FLAGS)
$(CALIBRE_TARGETS): $(CALIBRE_INPUT) $(CURDIR)/book.mk $(STANDARD_DEPS)
	$(CONVERT) $< $@ $(strip $(CONVERTFLAGS)) $(strip $(flavorflags))

%.pdf %.html %.txt: %.org $(EMACS_LOAD) $(STANDARD_DEPS)
	$(EMACS) $(EMACSFLAGS) \
                 $(EMACS_LOAD:%=-l %) \
		 --user $(USER) \
		 --batch \
		 --file "$<" \
		 --eval '$(strip $(export_elisp))'

$(BUILD_DIR):
	mkdir -p $@

skeleton: $(skeleton)

$(skeleton): | $(BUILD_DIR)
$(skeleton): $(ORGPRESS_ROOT)/skeleton.org.m4 $(CURDIR)/book.mk $(ORGPRESS_MAKEFILE) 
	m4 $(skeleton_defs) $< > $@

$(build_assets):
	mkdir -p $(@D)
	cp -r $(@:$(BUILD_DIR)/%=%) $@

.PRECIOUS: $(DEBUG_PRECIOUS_FILES) 

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

# Macro processor
M4			= m4
M4_INIT_FILE		= $(abspath $(ORGPRESS_ROOT)/init.m4)
M4FLAGS			= --prefix-builtins $(M4_INIT_FILE)

ifdef DEBUG
  EMACSFLAGS += --debug-init --eval '(setq debug-on-error t)'
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
--extra-css $(CALIBRE_STYLESHEET)
endef

# Calibre flags specific to Epub
define EPUB_FLAGS
--output-profile ipad
endef

# Calibre flags specific to Mobi
define MOBI_FLAGS
--output-profile kindle
endef

# The input HTML file for Calibre conversions
CALIBRE_INPUT		= $(abspath $(BUILD_DIR)/$(BOOK_NAME)$(flavor_suffix).html)

# Awk! Awk! Awk!
AWK			= gawk
AWKFLAGS		= 

# Some newfangled language from Japan
RUBY			= ruby
RUBYFLAGS		= -w

# LaTeX search path
export TEXINPUTS	= .:$(BUILD_DIR):$(ORGPRESS_ROOT):

# The LaTeX documentclass to use
LATEX_CLASS		= orgpress-report

# Strip out figures and listings, replace with placeholders
skeletonize_file	= $(abspath $(ORGPRESS_ROOT)/skeletonize.awk)
skel			= $(AWK) $(AWKFLAGS) -f $(skeletonize_file)
skelflags		= $(foreach var,listings_dir figures_dir FLAVOR,-v$(var)="$($(var))")

preplisting_file	= $(abspath $(ORGPRESS_ROOT)/preplisting.awk)
preplisting		= $(AWK) $(AWKFLAGS) -f $(preplisting_file)
preplistingflags	= $(foreach var,listings_dir FLAVOR,-v$(var)="$($(var))")

update_epub_manifest_file = $(abspath $(ORGPRESS_ROOT)/update-epub-manifest.rb)

### BOOK METADATA ###

# The basename of the book, for use in filenames
BOOK_NAME               = $(notdir $(CURDIR))

# The main org-mode source files
SOURCE_FILES		= $(realpath $(BOOK_NAME).org)

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

# The revision number
BOOK_REVISION		= 1

# The publication year
PUBYEAR			= $(firstword $(subst -, ,$(PUBDATE)))

# A PDF containing a cover page to insert at the beginning
export PDF_COVER        =

# Options for the LaTeX \includepdf command
export PDF_COVER_OPTS   = pages=1, noautoscale=true

COVER_IMAGE		=
MOBI_COVER		= $(COVER_IMAGE)
EPUB_COVER		= $(COVER_IMAGE)

# Org export customizations
HEADLINE_LEVELS		:= 5
TABLE_OF_CONTENTS	:= nil
SECTION_NUMBERS		:= nil

# Misc setup
BUILD_DIR		:= $(CURDIR)/build
export STYLESHEET	= $(abspath $(ORGPRESS_ROOT)/styles.css)
CALIBRE_STYLESHEET	= $(abspath $(ORGPRESS_ROOT)/calibre.css)
ALL_FLAVORS		= epub mobi pdf html tex txt
BUNDLE_FLAVORS		= epub mobi pdf
BUNDLE_FILE		= $(abspath $(BOOK_NAME).zip)

# Extra files or directories that the book depends on, e.g. images
# ASSETS			= 

FONTS			= $(abspath	$(ORGPRESS_ROOT)/fonts/Inconsolata.otf)

#					$(ORGPRESS_ROOT)/fonts/DroidSansMono.ttf)

FONT_LICENSES		= $(addsuffix -LICENSE.txt,$(basename $(FONTS)))
build_fonts		= $(addprefix $(BUILD_DIR)/,$(notdir $(FONTS)))
build_font_licenses	= $(addprefix $(BUILD_DIR)/,$(notdir $(FONT_LICENSES)))

# Flavors which require Calibre conversion
CALIBRE_FLAVORS		= epub mobi

# File targets Calibre can produce
CALIBRE_TARGETS		= $(foreach flavor,$(CALIBRE_FLAVORS),$(call flavor_file,$(flavor)))

# Flavors Org exports directly
ORG_EXPORT_FLAVORS      = pdf html

# File targets Org exports directly
ORG_EXPORT_TARGETS      = $(foreach flavor,$(ORG_EXPORT_FLAVORS),$(call flavor_file,$(flavor)))

# License files to include with the distributable bundle
LICENSES		= $(build_font_licenses)

# Files to bundle up in the deliverable
BUNDLE_FILES		= $(BUNDLE_FLAVORS:%=$(BUILD_DIR)/$(BOOK_NAME).%) $(LICENSES)

# Standard dependencies
STANDARD_DEPS		= $(ORGPRESS_MAKEFILE) $(BOOK_MAKEFILE) $(build_assets)

all_targets		= $(addprefix $(BOOK_NAME).,$(ALL_FLAVORS))
export_target		= $(BUILD_DIR)/$(BOOK_NAME).$(FLAVOR)
master			= $(BUILD_DIR)/master.org
master_vars		= BOOK_TITLE AUTHORS BOOK_REVISION PUBYEAR SOURCE_FILES sections_file listings_dir figures_dir latex_headers_file
define master_defs
$(strip $(foreach varname,$(master_vars),-D ORGPRESS_$(varname)="$($(varname))"))
endef
sections_file		= $(BUILD_DIR)/sections.org.m4
skeletons		= $(SOURCE_FILES:$(CURDIR)/%.org=$(BUILD_DIR)/%.skeleton$(flavor_suffix))
listings_dir		= $(BUILD_DIR)/listings$(flavor_suffix)
figures_dir		= $(BUILD_DIR)/figures_dir
latex_headers_file	= $(realpath $(ORGPRESS_ROOT)/headers.tex)	
minted_file		= $(abspath $(BUILD_DIR)/minted.sty)
listings		= $(wildcard $(listings_dir)/*.listing)
master_listings		= $(listings:%.listing=%.mlisting)
mlistings_timestamp	= $(BUILD_DIR)/master-listings$(flavor_suffix).timestamp

# Org flavor aliases
org_flavor_alias_txt	= text
org_flavor_alias_tex	= latex
org_flavor_alias_html   = html
org_flavor_alias_pdf    = pdf

### FUNCTIONS ###

# Given a flavor name (e.g. "mobi"), return the path of the
# corresponding output file
flavor_file		= $(BUILD_DIR)/$(BOOK_NAME).$(1)

# Given a filename, return the "flavor" of the file
# E.g. foo.mobi -> mobi
file_flavor		= $(subst .,,$(suffix $(1)))

# Convert a string to all-uppercase
uppercase		= $(shell echo $(1) | tr a-z A-Z)

define export_plist
:table-of-contents	$(TABLE_OF_CONTENTS)
:headline-levels	$(HEADLINE_LEVELS)
:section-numbers	$(SECTION_NUMBERS)
:language		$(LANGUAGE)
:latex-class		"$(LATEX_CLASS)"
:section-numbers	t
endef

define export_elisp
(progn
	(org-export-as-$(org_flavor_alias_$(FLAVOR))
		$(HEADLINE_LEVELS) 
		nil 
		(quote ($(export_plist)))))
endef

define emacs_export_command
	$(EMACS) $(EMACSFLAGS) \
                 $(EMACS_LOAD:%=-l %) \
		 --user $(USER) \
		 --file "$<" \
		 --eval '$(strip $(export_elisp))'
endef

define convert_command
	cd $(BUILD_DIR) &&
	$(CONVERT) $< $@ $(strip $(CONVERTFLAGS)) $(strip $(flavorflags)) &&
	zip -j $@ $(build_fonts) &&
	$(RUBY) $(RUBYFLAGS) $(update_epub_manifest_file) $@
endef

$(info OrgPress version $(ORGPRESS_VERSION))

ifdef DEBUG
  $(info Debug mode enabled)
  DEBUG_PRECIOUS_FILES = $(master) 
endif 

ifndef DEBUG
  EMACSFLAGS += --batch
endif

include $(BOOK_MAKEFILE)

ifneq ($(strip $(MOBI_COVER)),)
  MOBI_FLAGS +=  --cover "$(MOBI_COVER)"
endif

ifneq ($(strip $(EPUB_COVER)),)
  EPUB_FLAGS += --preserve-cover-aspect-ratio  --cover "$(EPUB_COVER)"
endif

build_assets = $(patsubst %,$(BUILD_DIR)/%,$(wildcard $(ASSETS)))

$(info Building $(BOOK_NAME))

default: bundle

bundle: $(BUNDLE_FILE)

$(BUNDLE_FILE): | $(STANDARD_DEPS)
$(BUNDLE_FILE): $(BUNDLE_FILES) $(BUNDLE_EXTRAS)
	-rm $@
	zip $@ -r $(BUNDLE_EXTRAS)
	zip $@ -j $(BUNDLE_FILES)

info:

clean:
	-rm -rf build

# This sets up shortcut targets for flavors, e.g.:
#   make epub
# Or:
#   make pdf
$(ALL_FLAVORS): export TARGET_FLAVOR=$@
$(ALL_FLAVORS): export FLAVOR=$(TARGET_FLAVOR)
$(ALL_FLAVORS): 
	$(MAKE) $(call flavor_file,$@)
	if [ -n "$(OPEN_TARGET)" ]; then $(OPEN) $(call flavor_file,$@); fi

ifndef flavor_suffix
  $(CALIBRE_TARGETS): export flavor_suffix=-$(TARGET_FLAVOR)
  $(CALIBRE_TARGETS): export flavorflags = $($(call uppercase,$(TARGET_FLAVOR))_FLAGS)
  $(CALIBRE_TARGETS): export FLAVOR=html
  $(CALIBRE_TARGETS):
	$(MAKE) $@
else
  $(CALIBRE_TARGETS): $(CALIBRE_INPUT) $(build_fonts) $(CURDIR)/book.mk $(STANDARD_DEPS)
	$(strip $(convert_command))
endif

%$(flavor_suffix).html: %$(flavor_suffix).org $(EMACS_LOAD) $(STANDARD_DEPS) $(STYLESHEET)
	$(emacs_export_command)

%.txt: %.org $(EMACS_LOAD) $(STANDARD_DEPS)
	$(emacs_export_command)

%.tex: %.org $(EMACS_LOAD) $(STANDARD_DEPS) $(minted_file) $(latex_headers_file) 
	$(emacs_export_command)

ifndef flavor_suffix
  %.pdf: export flavor_suffix=-pdf
  %.pdf: export FLAVOR=tex
  %.pdf:
	$(MAKE) $@
else 
  %.pdf: %.tex $(STANDARD_DEPS) $(PDF_COVER)
	-( cd $(@D); \
	   pdflatex -shell-escape -interaction nonstopmode -output-directory $(<D) $<; \
	   pdflatex -shell-escape -interaction nonstopmode -output-directory $(<D) $<; \
	   pdflatex -shell-escape -interaction nonstopmode -output-directory $(<D) $< )
endif

$(BUILD_DIR)/$(BOOK_NAME)$(flavor_suffix).org: $(master)
	cp $< $@

$(BUILD_DIR) $(listings_dir) $(figures_dir):
	mkdir -p $@

master: $(master)

$(mlistings_timestamp): $(skeletons) $(preplisting_file)
	$(MAKE) master-listings$(flavor_suffix)
	touch $@

master-listings$(flavor_suffix): $(master_listings)

# Order-only prerequisite on build dir
$(master): | $(BUILD_DIR)
$(master): $(abspath $(ORGPRESS_ROOT)/skeleton.org.m4) $(CURDIR)/book.mk $(ORGPRESS_MAKEFILE) $(sections_file) $(M4_INIT_FILE) $(mlistings_timestamp)
	$(M4) $(M4FLAGS) $(master_defs) $< > $@

$(sections_file): $(STANDARD_DEPS) $(skeletons)
	-rm $@
	for fn in $(skeletons); do echo "m4_include($${fn})" >> $@; done

$(build_assets):
	mkdir -p $(@D)
	cp -r $(@:$(BUILD_DIR)/%=%) $@

$(BUILD_DIR)/%.ttf: $(ORGPRESS_ROOT)/fonts/%.ttf
	cp $< $@
	cp $(basename $<)-LICENSE.txt $(@D)

$(BUILD_DIR)/%.otf: $(ORGPRESS_ROOT)/fonts/%.otf
	cp $< $@
	cp $(basename $<)-LICENSE.txt $(@D)

$(build_font_licenses):
	$(MAKE) $(build_fonts)

$(BUILD_DIR)/%.skeleton$(flavor_suffix): $(CURDIR)/%.org $(listings_dir) $(figures_dir) $(skeletonize_file) $(STANDARD_DEPS)
	$(skel) $(skelflags) $< > $@

$(minted_file):
	cd $(@D) && \
	wget "http://minted.googlecode.com/files/minted.sty"

# To make a master listing
%.mlisting: %.listing $(preplisting_file)
	$(preplisting) $(preplistingflags) $< > $@

.PRECIOUS: $(DEBUG_PRECIOUS_FILES)

# Targets that aren't files and never will be
.PHONY: $(ALL_FLAVORS) default info master clean master-listings$(flavor_suffix)

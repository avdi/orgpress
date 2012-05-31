################################################################################
# TOOLS
################################################################################
EMACS			= emacs
EMACS_INIT_FILE		= $(OP_LIB_DIR)/init.el
EMACS_LOAD		= $(EMACS_INIT_FILE)
EMACSFLAGS		= -Q $(EMACS_LOAD:%=-l %)

ifdef OP_DEBUG
  EMACSFLAGS += --debug-init --eval '(setq debug-on-error t)'
endif

ifndef DEBUG
  EMACSFLAGS += --batch
endif

################################################################################
# VARIABLES
################################################################################
EXPORT_FORMAT_EXTENSION ?= $(OP_FORMAT)

ORG_FORMAT_NAME		?= $(OP_FORMAT)

outputs			= $(OP_BOOK_NAME).$(EXPORT_FORMAT_EXTENSION)

# Org export customizations
OP_HEADLINE_LEVELS	?= 5
OP_TABLE_OF_CONTENTS	?= nil
OP_SECTION_NUMBERS	?= nil

define export_plist
:table-of-contents	$(OP_TABLE_OF_CONTENTS)
:headline-levels	$(OP_HEADLINE_LEVELS)
:section-numbers	$(OP_SECTION_NUMBERS)
:language		$(OP_LANGUAGE)
endef

define export_elisp
(progn
	(org-mode)
	(cd "$(CURDIR)")
	(org-export-as-$(ORG_FORMAT_NAME)
		$(OP_HEADLINE_LEVELS) 
		nil 
		(quote ($(export_plist))))
	(kill-emacs))
endef

define emacs_export_command
	$(EMACS) $(EMACSFLAGS) \
		 --file "$<" \
		 --eval '$(strip $(export_elisp))'
endef



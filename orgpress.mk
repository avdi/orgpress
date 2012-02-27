ORGPRESS_MAKEFILE	:= $(lastword $(MAKEFILE_LIST))
ORGPRESS_ROOT		:= $(dir $(ORGPRESS_MAKEFILE))
MAKEFILES		:= $(ORGPRESS_MAKEFILE)
ORGPRESS_VERSION	:= 0.0.1
EMACS			:= $(shell which emacs)
EMACS_VERSION		:= $(shell $(EMACS) --version | head -n1)
EMACS_INIT		:= $(ORGPRESS_ROOT)/init.el
BOOK_NAME               := $(notdir $(CURDIR))
SOURCE_FILE		:= $(BOOK_NAME).org
BOOK_TITLE		:= $(BOOK_NAME)
HEADLINE_LEVELS		:= 5
LOCALE			:= en-US
BUILD_DIR		:= $(CURDIR)/build
export STYLESHEET	:= $(ORGPRESS_ROOT)/styles.css

export_target		:= $(BUILD_DIR)/$(BOOK_NAME).$(FLAVOR)

define export_plist_calibre_elisp
:table-of-contents	nil
:headline-levels	$(HEADLINE_LEVELS)
:section-numbers	nil
:language		$(LOCALE)
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

default: export FLAVOR=calibre.html
default:
	$(MAKE) selected_flavor

selected_flavor: $(export_target)

$(export_target): $(EMACS_INIT) $(SOURCE_FILE)
	$(EMACS) $(EMACS_INIT:%=-l %) \
		--user $(USER) \
		--batch \
		--file $(SOURCE_FILE) \
		--eval '$(strip $(export_command_calibre_elisp))' \

$(BUILD_DIR):
	mkdir -p $@

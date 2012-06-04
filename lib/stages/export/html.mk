# Customize the InfoJS JavaScript applied to HTML views
export OP_INFOJS_PATH		= "http://orgmode.org/org-info.js"
export OP_INFOJS_SECTION_DEPTH	= "2"
export OP_INFOJS_BUTTONS	= "1"

# HTML TO insert at the top of HTML export
export OP_HTML_PREAMBLE_FILE	=
export OP_HTML_POSTAMBLE_FILE	=

export OP_STYLESHEET		= $(abspath $(OP_LIB_DIR)/styles.css)

define OP_STYLE_EXTRA
"<link rel=\"stylesheet\" type=\"text/css\" href=\"$(COMPOSITE_STYLESHEET)\"/>"
endef

export_plist			+= :style-extra $(OP_STYLE_EXTRA)


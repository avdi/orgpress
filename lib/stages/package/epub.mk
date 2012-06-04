include calibre.mk

CONVERTFLAGS		+= --output-profile kindle

CONVERT_FORMAT_EXTENSION = epub

define POSTPROCESS_CALIBRE_OUTPUT
$(ADD_FONTS_TO_ARCHIVE)
endef

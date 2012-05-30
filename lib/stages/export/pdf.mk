# The format is "latex", but the file extension is "tex"
EXPORT_FORMAT_EXTENSION = tex

# The LaTeX documentclass to use
OP_LATEX_CLASS		?= orgpress-report

export_plist		+= $(OP_LATEX_CLASS)

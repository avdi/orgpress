$(info $(shell env | grep OP_))
listings_dir		= $(CURDIR)
figures_dir		= $(CURDIR)
extract_file		= $(abspath $(OP_ROOT)/bin/extract.awk)
extract			= $(AWK) $(AWKFLAGS) -f $(extract_file)
extractflags		= $(foreach var,listings_dir figures_dir,-v$(var)="$($(var))")
outputs			= $(OP_BOOK_NAME).template

$(OP_BOOK_NAME).template: $(OP_BOOK_NAME).monolith
	$(extract) $(extractflags) $< > $@

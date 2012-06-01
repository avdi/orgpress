%.epub %.mobi: %.html
	$(CONVERT) $< $@ $(strip $(CONVERTFLAGS))

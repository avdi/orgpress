OP_PREREQUISITES		+= minted.sty

minted.sty:
	$(call fetch_url,"http://minted.googlecode.com/files/minted.sty",minted.sty)

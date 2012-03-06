m4_changequote(`[[[',`]]]')m4_dnl
m4_changecom([[[#-]]])m4_dnl

m4_divert([[[-1]]])

#- Get the listing filename for a given listing name
#- ORGPRESS_LISTING_FILE(listing_name)
m4_define([[[ORGPRESS_LISTING_FILE]]],[[[ORGPRESS_listings_dir/$1.mlisting]]])

#- Escape special LaTeX chars
#- ORGPRESS_ESCAPE_LATEX(text)
m4_define([[[ORGPRESS_ESCAPE_LATEX]]],
[[[m4_patsubst([[[$1]]],[_#%{}$],[[[\\\&]]])]]])

#- Output a fancy figure with caption
#- ORGPRESS_FANCY_FIGURE(filename, caption)
m4_define([[[ORGPRESS_FANCY_FIGURE]]],
[[[#+CAPTION: $2
[[$1]] ]]])

#- Output a code listing. Note: caption argument is now IGNORED.
m4_define([[[ORGPRESS_LISTING]]],
          [[[m4_include(ORGPRESS_LISTING_FILE($1))]]])

#- Output a figure, optionally with a caption
#- ORGPRESS_FIGURE(filename[, caption])
m4_define([[[ORGPRESS_FIGURE]]],
          [[[m4_ifelse($2,,
                       [[[ [[$1]] ]]],
                       [[[ORGPRESS_FANCY_FIGURE($1,$2)]]])]]])

#- OK, done defining macros
m4_divert

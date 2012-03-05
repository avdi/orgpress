m4_changequote(`[[[',`]]]')m4_dnl
m4_changecom([[[#-]]])m4_dnl

m4_divert([[[-1]]])

#- Get the listing filename for a given listing name
#- ORGPRESS_LISTING_FILE(listing_name)
m4_define([[[ORGPRESS_LISTING_FILE]]],[[[ORGPRESS_listings_dir/$1.listing]]])

#- Output a fancy code listing with a caption
#- ORGPRESS_FANCY_LISTING(listing_name, caption)
m4_define([[[ORGPRESS_FANCY_LISTING]]],
[[[#+HTML: <div class="listing">
#+LaTeX: \begin{listing}[H]
#+LaTeX: \caption{$2}
m4_include(ORGPRESS_LISTING_FILE($1))m4_dnl
#+LaTeX: \end{listing}
#+HTML: <div class="caption">$2</div>
#+HTML: </div>]]])m4_dnl

#- Output a fancy figure with caption
#- ORGPRESS_FANCY_FIGURE(filename, caption)
m4_define([[[ORGPRESS_FANCY_FIGURE]]],
[[[#+CAPTION: $2
[[$1]] ]]])

#- Output a code listing. When caption is provided, output a fancy listing.
#- ORGPRESS_LISTING(name [, caption])
m4_define([[[ORGPRESS_LISTING]]],
          [[[m4_ifelse($2,,
                       [[[m4_include(ORGPRESS_LISTING_FILE($1))]]],
                       [[[ORGPRESS_FANCY_LISTING($1,$2)]]])]]])

#- Output a figure, optionally with a caption
#- ORGPRESS_FIGURE(filename[, caption])
m4_define([[[ORGPRESS_FIGURE]]],
          [[[m4_ifelse($2,,
                       [[[ [[$1]] ]]],
                       [[[ORGPRESS_FANCY_FIGURE($1,$2)]]])]]])

#- OK, done defining macros
m4_divert

# "Skeletonize" a file by pulling out code listings and possibly other objects 
# into separate files, replacing them with placeholders in the source text.
#
# Required variables (these must be be set at the command line with -vkey=value)
#
#   - listings_dir
#   - figures_dir
#
BEGIN { 
    # Ignore case in all regexps
    IGNORECASE = 1 
    caption_pattern = /^[[:space:]]*#\+CAPTION:/
}

function start_listing()
{
    ++listing_count 
    ("basename " FILENAME " .org") | getline basename 
    formatted_count = sprintf("%03d", listing_count)
    listing_name    = (basename "-" formatted_count)
    listing_file    = (listings_dir "/" listing_name ".listing")
    system("rm " listing_file "> /dev/null 2>&1")
    print_metadata(listing_file)
    if(caption)
        print "ORGPRESS_LISTING(" listing_name ",[[[" caption  "]]])"
    else
        print "ORGPRESS_LISTING(" listing_name ")"
    caption = ""
}

function print_metadata(file)
{
    ORS = "\r\n"
    print "filename: " FILENAME >file
    print "number: " listing_count >file
    print "name: " listing_name >file
    print "flavor: " FLAVOR >file
    if(caption)
        print "caption: " caption >file
    print "" >file
    ORS = "\n"
}

/^[[:space:]]*#\+BEGIN_SRC/     { start_listing() }
/^[[:space:]]*#\+BEGIN_EXAMPLE/ { start_listing() }
/^[[:space:]]*#\+BEGIN_SRC/,/^[[:space:]]*#\+END_SRC/ { 
    print >listing_file
    next
}
/^[[:space:]]*#\+BEGIN_EXAMPLE/,/^[[:space:]]*#\+END_EXAMPLE/ { 
    print >listing_file
    next
}
# Inline image links
/^[[:space:]]*\[\[.*\.(png|jpeg|eps|jpg)\]\][[:space:]]*/ {
    match($0, /\[\[(.*)]\]/, matches)
    figure_file = matches[1]
    if(caption)
        print "ORGPRESS_FIGURE(" figure_file ",[[[" caption  "]]])"
    else
        print "ORGPRESS_FIGURE(" figure_file ")"
    caption = ""
    next
}
/^[[:space:]]*#\+CAPTION:/ {
    caption = $0
    sub(/^[[:space:]]*#\+CAPTION:[[:space:]]*/,"",caption)
    next
}
{ print }


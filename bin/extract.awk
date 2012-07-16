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
    listings_file   = "LISTINGS"
    role            = "source"
}

function start_listing()
{
    ++listing_count 
    ("basename " FILENAME " .monolith") | getline basename 
    formatted_count  = sprintf("%03d", listing_count)
    listing_name     = (basename "-" formatted_count)
    listing_basename = (listing_name ".listing")
    listing_file     = (listings_dir "/" listing_basename)
    system("rm " listing_file "> /dev/null 2>&1")
    print listing_basename >listings_file
    print_metadata(listing_file)

    if(header_arguments[":exports",0] == "results") {
        suppress_inclusion = 1
        awaiting_results   = 1
    }
}

function end_listing() {
    if(!suppress_inclusion) {
        if(caption)
            print "ORGPRESS_LISTING(" listing_name ",«" caption  "»)"
        else
            print "ORGPRESS_LISTING(" listing_name ")"
    }
    if(!awaiting_results) {
        caption = ""
    }
    if(getting_results) {
        awaiting_results = 0
    }
    role               = "source"
    identifier         = 0
    getting_results    = 0
    suppress_inclusion = 0
}

function start_source_listing() {
    delete header_arguments
    current_argument = "MISC"
    for(i=3; i<NF; i++) {
        if($i ~ /^:/) {
            current_argument = $i
            value_index      = 0
        } else {
            current_value = header_arguments[current_argument]
            header_arguments[current_argument] = (current_value " " $i)
            header_arguments[current_argument,value_index] = $i
        }
    }
}

function print_metadata(file)
{
    ("basename " FILENAME) | getline source_name
    ORS = "\r\n"
    print "filename: " source_name >file
    print "number: " listing_count >file
    print "name: " listing_name >file
    if(identifier)
        print "identifier: " identifier >file
    print "role: " role >file
    if(caption)
        print "caption: " caption >file
    print "" >file
    ORS = "\n"
}

/^[[:space:]]*#\+BEGIN_SRC/ { 
    role = "source"
    start_source_listing() 
    start_listing()
}
/^[[:space:]]*#\+BEGIN_EXAMPLE/  { 
    role = "output"
    start_listing() 
}

/^[[:space:]]*#\+END_(SRC|EXAMPLE)/ {
    end_listing()
}
/^[[:space:]]*#\+RESULTS.*:/ {
    getting_results = 1
    next
}
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
        print "ORGPRESS_FIGURE(" figure_file ",«" caption  "»)"
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
$1 ~ /#\+NAME:/ {
    identifier = $2
    next
}
{ print }


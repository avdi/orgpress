BEGIN {
    # Ignore case in all regexps
    IGNORECASE = 1 
    max_lines = 42

    # Start out parsing metadata in RFC2822 format
    RS = "\r\n"
}

function start_listing(type,line) {
    line_count   = 0
    offset       = 0
    listing_type = type
    print_listing_header(caption)
    header_line  = line
}

function end_listing() {
    print_listing_footer()
}

function on_listing_line() {
    if( (!/^[[:space:]]*#\+BEGIN_/ || /^[[:space:]]*#\+END_/) )
        ++line_count
    if(line_count >= max_lines)
        split_listing()
}

function on_metadata_end() {
    done_metadata=1
    caption = escape(metadata["caption"])
    RS="\n"
}

function split_listing() {
    if((FLAVOR != "tex") && (FLAVOR != "pdf"))
        return
    print "#+END_" listing_type
    print_listing_footer()
    print_listing_header(caption " (continued)")
    print header_line
    offset     = line_count
    line_count = 0
}

function print_listing_header(listing_caption) {
    if(caption)
        print_fancy_listing_header(listing_caption)
}

function print_listing_footer() {
    if(caption)
        print_fancy_listing_footer()
}

function print_fancy_listing_header(listing_caption) {
    print "#+HTML: <div class=\"listing\">"
    print "#+LaTeX: \\begin{listing}[H]"
    print "#+LaTeX: \\caption{" listing_caption "}"
}

function print_fancy_listing_footer() {
    print "#+LaTeX: \\end{listing}"
    print "#+HTML: <div class=\"caption\">" caption "</div>"
    print "#+HTML: </div>"
}

function escape(str) {
    return gensub(/[_#%{}$]/, "\\\\&", "g", str)
}

/^$/ {
    on_metadata_end()
    next
}

(!done_metadata) && ($0 ~ /\w+: /){
    match($0, /^(\w+): (.*)/, matches)
    metadata[matches[1]] = matches[2]
    next
}

/^[[:space:]]*#\+BEGIN_SRC/     { start_listing("SRC",$0) }
/^[[:space:]]*#\+BEGIN_EXAMPLE/ { start_listing("EXAMPLE",$0) }
/^[[:space:]]*#\+END_SRC/       {
    print
    end_listing()
    next
}
/^[[:space:]]*#\+END_EXAMPLE/   { end_listing()   }

/^[[:space:]]*#\+BEGIN_SRC/,/^[[:space:]]*#\+END_SRC/ { 
    on_listing_line()
}
/^[[:space:]]*#\+BEGIN_EXAMPLE/,/^[[:space:]]*#\+END_EXAMPLE/ { 
    on_listing_line()
}
{ print }

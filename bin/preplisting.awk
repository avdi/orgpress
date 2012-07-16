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
    indent_col   = 0
    listing_type = type
    content_type = determine_content_type(line)
    print_listing_header(caption)
    header_line  = line
    format_coprocess = determine_format_coprocess(content_type)
    if(FLAVOR != "html") {
        print
    }
}

function end_listing() {
    if(format_coprocess) {
        close(format_coprocess, "to")
        while ((format_coprocess |& getline formatted_line) > 0)
            print formatted_line
        close(format_coprocess)
    }
    print_listing_footer()
}

function on_listing_line() {
    if( (!/^[[:space:]]*#\+BEGIN_/ || /^[[:space:]]*#\+END_/) ) {
        ++line_count
        if(line_count == 1) {
            # determine indent based on position of first non-space char
            indent_col = match($0,/[^[:space:]]/)
        }
        # Remove indent
        $0 = substr($0, indent_col)
        if(format_coprocess) {
            print |& format_coprocess
        } else {
            print
        }
    }
    if(line_count >= max_lines)
        split_listing()
}

function on_metadata_end() {
    done_metadata=1
    caption = escape(metadata["caption"])
    role    = metadata["role"]
    if(!role)
        role = "source"
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
    if(FLAVOR == "html") {
        print "#+BEGIN_HTML"
        print listing_start_tag()
    } else {
        if(caption)
            print_fancy_listing_header(listing_caption)
        if(metadata["identifier"])
            print "#+NAME: " metadata["identifier"]
    }
}

function print_listing_footer() {
    if(FLAVOR == "html") {
        if(caption) {
            print "<div class=\"caption\">" caption "</div>"
        }
        print "</div>"
        print "#+END_HTML"
    } else if(caption) {
        print_fancy_listing_footer()
    }
}

function print_fancy_listing_header(listing_caption) {
    print "#+HTML: " listing_start_tag()
    print "#+LaTeX: \\begin{listing}[H]"
    print "#+LaTeX: \\caption{" listing_caption "}"
}

function print_fancy_listing_footer() {
    print "#+LaTeX: \\end{listing}"
    print "#+HTML: <div class=\"caption\">" caption "</div>"
    print "#+HTML: </div>"
}

function escape(str) {
    if(FLAVOR ~ /(tex|pdf)/) {
        return gensub(/[_#%{}$]/, "\\\\&", "g", str)
    } else if(FLAVOR ~ /(html|epub|mobi)/) {
        str = gensub(/&/, "&amp;", "g", str)
        str = gensub(/</, "&lt;", "g", str)
        str = gensub(/>/, "&gt;", "g", str)
        return str
    } else {
        return str
    }
}

function determine_content_type(header_line) {
    split(header_line, header_line_fields, " ")
    if(header_line_fields[2])
        return tolower(header_line_fields[2])
    else
        return "text"
}

function determine_format_coprocess(content_type) {
    if(FLAVOR ~ /(html|epub|mobi)/) {
        return ("pygmentize -l " content_type " -f html")
    }
}

function listing_start_tag() {
    return "<div class=\"listing " role "\">"
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
    if(FLAVOR != "html") {
        print
    }
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


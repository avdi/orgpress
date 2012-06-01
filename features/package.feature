@slow
Feature: Package files to platform target formats

  Background:
    Given prerequisites have been fetched

  Scenario: Package files
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    assets:
      - images/*.jpg
      - fonts/myfont.otf
    """
    And a file named "images/foo.jpg"
    And a file named "images/bar.txt"
    And a file named "junk/junk.txt"
    And a file named "fonts/myfont.otf"
    And a file named "build/export/html/the-foo-book.html" with:
    """
    <html>
      <head><title>The Foo Book</title></head>
      <body>
        <h1>Chapter 1</h1>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
        <img src="./images/foo.jpg"/>
      </body>
    </html>
    """
    And a file named "build/export/kindle/the-foo-book.html" with:
    """
    <html>
      <head><title>The Foo Book</title></head>
      <body>
        <h1>Chapter 1</h1>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
        <img src="./images/foo.jpg"/>
      </body>
    </html>
    """
    And a file named "build/export/epub/the-foo-book.html" with:
    """
    <html>
      <head><title>The Foo Book</title></head>
      <body>
        <h1>Chapter 1</h1>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
        <img src="./images/foo.jpg"/>
      </body>
    </html>
    """
    And a file named "build/export/pdf/the-foo-book.tex" with:
    """
    \documentclass{report}
    \input{headers}

    \title{The Foo Book}
    \author{Avdi Grimm}
    \date{11 July 2011}

    \begin{document}

    \setcounter{tocdepth}{5}

    \chapter{About}

    \label{sec-1}

    Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

    \begin{listing}[H]
    \caption{Hello world in Ruby}
    \begin{minted}[linenos=true,fontsize=\small,framesep=1ex,frame=single,stepnumber=5]{ruby}
    puts "hello, world"
    \end{minted}
    \end{listing}

    \end{document}
    """
    When I run `orgpress package`
    Then the exit status should be 0
    Then a file named "build/package/kindle/the-foo-book.mobi" should exist
    And a file named "build/package/epub/the-foo-book.epub" should exist
    And a file named "build/package/pdf/the-foo-book.pdf" should exist
    And a file named "build/package/html/the-foo-book.html.zip" should exist
    When I unpack "build/package/epub/the-foo-book.epub" into "unpack-epub"
    Then a file named "unpack-epub/the-foo-book.html" should exist
    Then a file named "unpack-epub/foo.jpg" should exist
    Then a file named "unpack-epub/fonts/myfont.otf" should exist
    Then a file named "unpack-epub/images/bar.txt" should not exist
    Then a file named "unpack-epub/junk/junk.txt" should not exist
    When I unpack "build/package/html/the-foo-book.html.zip" into "unpack-html"
    Then a file named "unpack-html/the-foo-book.html" should exist
    Then a file named "unpack-html/images/foo.jpg" should exist
    Then a file named "unpack-html/fonts/myfont.otf" should exist
    

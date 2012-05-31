@reallyslow
Feature: Expand stage

  Scenario: Expand macros
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    title: The Foo Book
    author: Avdi Grimm
    """
    And a file named "build/extract/neutral/the-foo-book.template" with:
    """
    #+TITLE: OP_TITLE
    #+AUTHOR: OP_AUTHOR

    Neutral listing:

    ORGPRESS_LISTING(the-foo-book-001)

    Listing with caption:

    ORGPRESS_LISTING(the-foo-book-002,«caption for listing»)

    Figure without caption:

    ORGPRESS_FIGURE(./foo.jpg)

    Figure with caption:

    ORGPRESS_FIGURE(./bar.png,«caption for figure»)

    """
    And a file named "build/prepare-objects/neutral/the-foo-book-001.mlisting" with:
    """
    #+BEGIN_SRC ruby
    puts "this is listing 1"
    #+END_SRC
    """
    And a file named "build/prepare-objects/pdf/the-foo-book-001.mlisting" with:
    """
    #+BEGIN_SRC ruby
    puts "this is listing 1 for PDF only"
    #+END_SRC
    """
    And a file named "build/prepare-objects/neutral/the-foo-book-002.mlisting" with:
    """
    #+BEGIN_SRC ruby
    puts "this is listing 2"
    #+END_SRC
    """
    When I run `orgpress expand`
    Then the exit status should be 0
    Then a directory named "build/expand" should exist
    And a directory named "build/expand/neutral" should exist
    And the file "build/expand/neutral/the-foo-book.master" should contain exactly:
    """
    #+TITLE: The Foo Book
    #+AUTHOR: Avdi Grimm

    Neutral listing:

    #+BEGIN_SRC ruby
    puts "this is listing 1"
    #+END_SRC

    Listing with caption:

    #+BEGIN_SRC ruby
    puts "this is listing 2"
    #+END_SRC

    Figure without caption:

    [[./foo.jpg]]

    Figure with caption:
    
    #+CAPTION: caption for figure
    [[./bar.png]]


    """
    And the file "build/expand/html/the-foo-book.master" should contain exactly:
    """
    #+TITLE: The Foo Book
    #+AUTHOR: Avdi Grimm

    Neutral listing:

    #+BEGIN_SRC ruby
    puts "this is listing 1"
    #+END_SRC

    Listing with caption:

    #+BEGIN_SRC ruby
    puts "this is listing 2"
    #+END_SRC

    Figure without caption:

    [[./foo.jpg]]

    Figure with caption:
    
    #+BEGIN_HTML
    <div class="figure">
      <img src="./bar.png" alt="caption for figure"/>
      <div class="caption">caption for figure</div>
    </div>
    #+END_HTML


    """
    And the file "build/expand/pdf/the-foo-book.master" should contain exactly:
    """
    #+TITLE: The Foo Book
    #+AUTHOR: Avdi Grimm

    Neutral listing:

    #+BEGIN_SRC ruby
    puts "this is listing 1 for PDF only"
    #+END_SRC

    Listing with caption:

    #+BEGIN_SRC ruby
    puts "this is listing 2"
    #+END_SRC

    Figure without caption:

    [[./foo.jpg]]

    Figure with caption:
    
    #+CAPTION: caption for figure
    [[./bar.png]]


    """
    

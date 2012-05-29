Feature: Extract objects

  Scenario: Extract source listings
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/concatenate/neutral/the-foo-book.monolith" with:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    #+BEGIN_SRC ruby
      def foo
        puts "hello, world"
      end
    #+END_SRC

    #+CAPTION: goodbye in ruby
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    This paragraph is below the code listing.
    """
    When I run `orgpress extract`
    Then the exit status should be 0
    And the file "build/extract/neutral/the-foo-book.template" should contain exactly:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    ORGPRESS_LISTING(the-foo-book-001)

    ORGPRESS_LISTING(the-foo-book-002,[[[goodbye in ruby]]])

    This paragraph is below the code listing.

    """
    And the file "build/extract/neutral/the-foo-book-001.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    
    #+BEGIN_SRC ruby
      def foo
        puts "hello, world"
      end
    #+END_SRC

    """
    And the file "build/extract/neutral/the-foo-book-002.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 2
    name: the-foo-book-002
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    """
    And the file "build/extract/neutral/LISTINGS" should contain exactly:
    """
    the-foo-book-001.listing
    the-foo-book-002.listing

    """

  Scenario: Extract figures
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/concatenate/neutral/the-foo-book.monolith" with:
    """
    * Chapter 1: Hello world
    
    [[./foo.jpg]]

    Some text...

    #+CAPTION: caption for bar
    [[./bar.png]]

    """
    When I run `orgpress extract`
    Then the exit status should be 0
    And the file "build/extract/neutral/the-foo-book.template" should contain exactly:
    """
    * Chapter 1: Hello world
    
    ORGPRESS_FIGURE(./foo.jpg)

    Some text...

    ORGPRESS_FIGURE(./bar.png,[[[caption for bar]]])

    """


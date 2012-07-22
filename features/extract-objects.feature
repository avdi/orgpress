@slow
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

    #+name: hello
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

    #+name: fizz
    #+BEGIN_SRC ruby
    def fizz; end
    #+END_SRC
    
    #+name: buzz
    #+BEGIN_SRC ruby :tangle yes :noweb strip-export :tangle buzz
    <<fizz>>
    def buzz; end
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

    ORGPRESS_LISTING(the-foo-book-002,«goodbye in ruby»)

    ORGPRESS_LISTING(the-foo-book-003)

    ORGPRESS_LISTING(the-foo-book-004)

    This paragraph is below the code listing.

    """
    And the file "build/extract/neutral/the-foo-book-001.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    identifier: hello
    role: source
    
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
    role: source
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    """
    And the file "build/extract/neutral/the-foo-book-003.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 3
    name: the-foo-book-003
    identifier: fizz
    role: source
    
    #+BEGIN_SRC ruby
    def fizz; end
    #+END_SRC

    """
    And the file "build/extract/neutral/the-foo-book-004.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 4
    name: the-foo-book-004
    identifier: buzz
    role: source
    
    #+BEGIN_SRC ruby :tangle yes :noweb strip-export :tangle buzz
    def buzz; end
    #+END_SRC

    """
    And the file "build/extract/neutral/LISTINGS" should contain exactly:
    """
    the-foo-book-001.listing
    the-foo-book-002.listing
    the-foo-book-003.listing
    the-foo-book-004.listing

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

    ORGPRESS_FIGURE(./bar.png,«caption for bar»)

    """

  Scenario: Extract result blocks
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/concatenate/neutral/the-foo-book.monolith" with:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    #+RESULTS[4929174df650d3153bb719f487000dead67398ed]:
    #+BEGIN_EXAMPLE
      def foo
        puts "hello, world"
      end
    #+END_EXAMPLE

    This paragraph is below the code listing.
    """
    When I run `orgpress extract`
    Then the exit status should be 0
    And the file "build/extract/neutral/the-foo-book.template" should contain exactly:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    ORGPRESS_LISTING(the-foo-book-001)

    This paragraph is below the code listing.

    """
    And the file "build/extract/neutral/the-foo-book-001.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    role: output
    
    #+BEGIN_EXAMPLE
      def foo
        puts "hello, world"
      end
    #+END_EXAMPLE

    """
    And the file "build/extract/neutral/LISTINGS" should contain exactly:
    """
    the-foo-book-001.listing

    """

  Scenario: Extract generated source code
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/concatenate/neutral/the-foo-book.monolith" with:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    #+CAPTION: Hello World in Ruby
    #+BEGIN_SRC ruby :exports results :results xmp code
      def foo
        puts "hello, world"
      end
      foo # => nil
    #+END_SRC

    #+RESULTS[4929174df650d3153bb719f487000dead67398ed]:
    #+BEGIN_SRC ruby
      def foo
        puts "hello, world"
      end
      foo # => nil
    #+END_SRC

    This paragraph is below the code listing.
    """
    When I run `orgpress extract`
    Then the exit status should be 0
    And the file "build/extract/neutral/the-foo-book.template" should contain exactly:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.


    ORGPRESS_LISTING(the-foo-book-002,«Hello World in Ruby»)

    This paragraph is below the code listing.

    """
    And the file "build/extract/neutral/the-foo-book-002.listing" should contain exactly:
    """
    filename: the-foo-book.monolith
    number: 2
    name: the-foo-book-002
    role: source
    caption: Hello World in Ruby
    
    #+BEGIN_SRC ruby
      def foo
        puts "hello, world"
      end
      foo # => nil
    #+END_SRC

    """
    And the file "build/extract/neutral/LISTINGS" should contain exactly:
    """
    the-foo-book-001.listing
    the-foo-book-002.listing

    """

Feature: Concatenate signatures

  Scenario: Concatenate signatures into a single file
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    sources:
      - chapter1.markdown
      - chapter2.org
    """
    And a file named "chapter1.markdown" with:
    """
    # Chapter 1: Hello world
      
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. 
    """
    And a file named "chapter2.org" with:
    """
    * Chapter 2
    
    This paragraph is above the code listing.

    #+BEGIN_SRCruby
      def foo
        puts "hello, world"
      end
    #+END_SRC

    This paragraph is below the code listing.

    """
    When I run `orgpress normalize`
    Then the exit status should be 0
    When I run `orgpress concatenate`
    Then the exit status should be 0
    Then a directory named "build/concatenate" should exist
    And a directory named "build/concatenate/neutral" should exist
    And the file "build/concatenate/neutral/the-foo-book.monolith" should contain exactly:
    """
    * Chapter 1: Hello world

    Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    * Chapter 2
    
    This paragraph is above the code listing.

    #+BEGIN_SRCruby
      def foo
        puts "hello, world"
      end
    #+END_SRC

    This paragraph is below the code listing.

    """

    
    

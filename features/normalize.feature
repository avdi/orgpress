Feature: Normalize Stage

  Scenario: Convert markdown to org
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "the-foo-book.markdown" with:
    """
    # Chapter 1: Hello world
      
    This paragraph is above the code listing.

    ```ruby
    def foo
      puts "hello, world"
    end
    ```

    This paragraph is below the code listing.
    """
    When I run `orgpress normalize`
    Then the exit status should be 0
    Then a directory named "build/normalize" should exist
    And a directory named "build/normalize/neutral" should exist
    And the file "build/normalize/neutral/the-foo-book.org" should contain exactly:
    """
    * Chapter 1: Hello world
    
    This paragraph is above the code listing.

    #+BEGIN_SRC ruby
        def foo
          puts "hello, world"
        end
    #+END_SRC

    This paragraph is below the code listing.

    """

  Scenario: Normalize front and back matter
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    frontmatter:
      - preface.markdown
    sources:
      - chapter1.org
    backmatter:
      - back.markdown
    """
    And a file named "preface.markdown" with:
    """
    # Preface

    """
    And a file named "chapter1.org" with:
    """
    * Chapter 1
    
    This is the body.

    """
    And a file named "back.markdown" with:
    """
    # Bibliography

    """
    When I run `orgpress normalize`
    Then the exit status should be 0
    And the file "build/normalize/neutral/preface.org" should contain exactly:
    """
    * Preface
    
    """
    And the file "build/normalize/neutral/back.org" should contain exactly:
    """
    * Bibliography
    
    """


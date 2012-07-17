@reallyslow
Feature: Export to format

  Scenario: Export to format
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "the-foo-book.master" with:
    """
    #+DATE: 2012-07-16
    * Chapter 1

    The /quick brown/ fox jumped over the *lazy* =dog=.

    #+BEGIN_SRC ruby
      puts "hello, world"
    #+END_SRC

    #+BEGIN_EXAMPLE
      hello, world
    #+END_EXAMPLE

    Figure 1:

    [[./fig1.jpg]]
    """
    When I run `orgpress export`
    Then the exit status should be 0
    And a file named "build/export/html/the-foo-book.html" should exist
    And the file "build/export/html/the-foo-book.html" should contain:
    """
    <link rel="stylesheet" type="text/css" href="op-composite-stylesheet.css"/>
    """
    And a file named "build/export/kindle/the-foo-book.html" should exist
    And a file named "build/export/epub/the-foo-book.html" should exist
    And a file named "build/export/pdf/the-foo-book.tex" should exist
    And a file named "build/export/text/the-foo-book.txt" should exist
    And the file "build/export/text/the-foo-book.txt" should contain exactly:
    """
                                 the-foo-book
                                 ============

    Author: Avdi Grimm
    Date: 2012-07-16


    Chapter 1 
    ----------

    The /quick brown/ fox jumped over the *lazy* =dog=.



      puts "hello, world"




      hello, world


    Figure 1:

    [./fig1.jpg]

    """


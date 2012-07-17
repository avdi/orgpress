@slow
Feature: Bundle files into a deliverable archive

  Scenario: Bundle files
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/package/kindle/the-foo-book.mobi"
    And a file named "build/package/epub/the-foo-book.epub"
    And a file named "build/package/pdf/the-foo-book.pdf"
    And a file named "build/package/html/the-foo-book.html.zip"
    And a file named "build/export/text/the-foo-book.txt"
    When I run `orgpress bundle`
    Then the exit status should be 0
    And a file named "build/bundle/neutral/the-foo-book.zip" should exist
    When I unpack "build/bundle/neutral/the-foo-book.zip" into "unpack"
    Then a file named "unpack/the-foo-book.mobi" should exist
    And a file named "unpack/the-foo-book.epub" should exist
    And a file named "unpack/the-foo-book.pdf" should exist
    And a file named "unpack/the-foo-book.html.zip" should exist
    And a file named "unpack/the-foo-book.txt" should exist


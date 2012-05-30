@slow
Feature: Concatenate signatures

  Scenario: Concatenate signatures into a single file
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    sources:
      - chapter1.markdown
      - chapter2.org
    """
    And a file named "build/normalize/neutral/chapter1.org" with:
    """
    * Chapter 1: Hello world
    
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
    When I run `orgpress concatenate`
    Then the exit status should be 0
    Then a directory named "build/concatenate" should exist
    And a directory named "build/concatenate/neutral" should exist
    And the file "build/concatenate/neutral/the-foo-book.monolith" should contain exactly:
    """
    #+TITLE: OP_TITLE
    #+AUTHOR: OP_AUTHOR
    #+LaTeX_HEADER: \input{orgpress_headers}
    #+LaTeX: \tableofcontents
    #+LaTeX: \listoflistings
    #+LaTeX: \listoffigures
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

  Scenario: Custom front and back-matter
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    frontmatter:
      - preface.org
      - intro.org
    sources:
      - chapter1.org
    backmatter:
      - back.org
    """
    And a file named "preface.org" with:
    """
    * Preface

    """
    And a file named "intro.org" with:
    """
    * Introduction

    """
    And a file named "chapter1.org" with:
    """
    * Chapter 1
    
    This is the body.

    """
    And a file named "back.org" with:
    """
    * Bibliography

    """
    When I run `orgpress concatenate`
    Then the exit status should be 0
    Then a directory named "build/concatenate" should exist
    And a directory named "build/concatenate/neutral" should exist
    And the file "build/concatenate/neutral/the-foo-book.monolith" should contain exactly:
    """
    * Preface
    * Introduction
    * Chapter 1

    This is the body.
    * Bibliography

    """

    
    

    
    

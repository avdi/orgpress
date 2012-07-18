@slow
Feature: Distribute files

  Scenario: Distribute files
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And an executable file named ".orgpress/hooks/distribute/fake" with:
    """
    #!/bin/sh
    echo $* | xargs -n1 basename >> ${OP_BOOK_DIR}/fake-distributor.log

    """
    And a file named "build/bundle/neutral/the-foo-book.zip"
    When I run `orgpress distribute`
    Then the exit status should be 0
    And a file named "build/distribute/neutral/fake.dist-timestamp" should exist
    And the file "fake-distributor.log" should contain exactly:
    """
    the-foo-book.zip

    """
    When I run `orgpress distribute`
    Then the exit status should be 0
    And the file "fake-distributor.log" should contain exactly:
    """
    the-foo-book.zip

    """
    When I run `touch build/bundle/neutral/the-foo-book.zip`
    And I run `orgpress distribute`
    Then the exit status should be 0
    And the file "fake-distributor.log" should contain exactly:
    """
    the-foo-book.zip
    the-foo-book.zip

    """
    

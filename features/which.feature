Feature: `orgpress which` command

  Scenario: Use `orgpress which` to find the path to a built file
    Given a file named "FOO"
    And a file named "BAR"
    And a file named "BAZ"
    And a file named "BUZ"
    And a file named "html/BAR"
    And a file named "pdf/BAR"
    And a file named "build/normalize/neutral/BAZ"
    And a file named "build/normalize/pdf/BAZ"
    And a file named "build/normalize/neutral/BUZ"
    And a file named "build/concatenate/neutral/BUZ"
    And a file named "build/concatenate/html/BUZ"
    When I run `orgpress which FOO`
    Then the exit status should be 0
    And the output should contain "FOO"
    When I run `orgpress which FOOZ`
    Then the exit status should be 1
    When I run `orgpress which BAR`
    Then the output should contain "BAR"
    When I run `orgpress which BAR --platform pdf`
    Then the output should contain "pdf/BAR"
    When I set "OP_PLATFORM" to "pdf"
    And I run `orgpress which BAR`
    Then the output should contain "pdf/BAR"
    When I unset "OP_PLATFORM"
    And I run `orgpress which BAR --platform html`
    Then the output should contain "html/BAR"
    When I run `orgpress which BAR --platform kindle`
    Then the output should contain "BAR"
    When I run `orgpress which BAZ`
    Then the output should contain "build/normalize/neutral/BAZ"
    When I run `orgpress which BAZ --platform pdf`
    Then the output should contain "build/normalize/pdf/BAZ"
    When I run `orgpress which BUZ`
    Then the output should contain "build/concatenate/neutral/BUZ"
    When I run `orgpress which BUZ --platform html`
    Then the output should contain "build/concatenate/html/BUZ"
    When I run `orgpress which BUZ --stage normalize`
    Then the output should contain "build/normalize/neutral/BUZ"
    When I run `orgpress which BUZ --stage concatenate --no-include-current`
    Then the output should contain "build/normalize/neutral/BUZ"



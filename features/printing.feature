@envjs
Feature: Printing

  Background:
    Given Resque is clear

  @print
  Scenario: A single letter
    Given I have mailed 1 legislator
    When  the "high" job is processed
    Then  the letter should be marked as printed
    And   I should receive the print confirmation email
    And   I should receive a notification email 5 days later

  @stubprint
  Scenario: A single letter, printing stubbed out
    Given print jobs have been stubbed out
    And   I have mailed 1 legislator
    When  the "high" job is processed
    Then  the letter should be marked as printed
    And   I should receive the print confirmation email
    And   I should receive a notification email 5 days later

Feature: Printing

  @print
  Scenario: A single letter
    Given a new enqueued letter with 1 recipient
    When  the job is processed
    Then  the letter should be marked as printed
    And   I should receive the print confirmation email

  @stubprint
  Scenario: A single letter, printing stubbed out
    Given print jobs have been stubbed out
    And   a new enqueued letter with 1 recipient
    When  the job is processed
    Then  the letter should be marked as printed
    And   I should receive the print confirmation email

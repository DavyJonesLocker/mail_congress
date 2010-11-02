@print
Feature: Printing

  Scenario: A single letter
    Given a new enqueued letter with 1 recipient
    When  the job is processed
    Then  the letter should be marked as printed

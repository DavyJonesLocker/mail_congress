@followup
Feature: Follow up phone call

  Background:
    Given Resque is clear

  Scenario: Making a follow up phone call
    Given print jobs have been stubbed out
    And   I have mailed 1 legislator
    When  the "high" job is processed
    Then  I should receive a notification email 5 days later
    When  I make a follow up phone call

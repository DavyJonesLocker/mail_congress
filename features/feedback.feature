@feedback
Feature: Feedback

  Scenario: Submitting proper feedback
    Given I am on the home page
    When  I follow "Feedback"
    And   I submit feedback
    Then  my feedback should be sent

  Scenario: Submitting improper feedback
    Given I am on the home page
    When  I follow "Feedback"
    When  I press "Submit"
    Then  I should see errors for the feedback

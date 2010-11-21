@envjs
Feature: Paying for letters

  Scenario: Mailing my congress people
    Given I have found my congress people
    When  I write my letter to all of my congress people
    And   I pay for the letters with my credit card
    Then  My letters should be on their way

  Scenario: Submitting no payment information
    Given I have found my congress people
    When  I write my letter to all of my congress people
    And   I clear all of the fields
    And   I press "Make secure payment"
    Then  I should see the errors for the payment


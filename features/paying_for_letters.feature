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
    And   I press "Make payment"
    Then  I should see the error "can't be blank" for "Email"
    And   I should see the error "can't be blank" for "First name"
    And   I should see the error "can't be blank" for "Last name"
    And   I should see the error "can't be blank" for "Street address"
    And   I should see the error "can't be blank" for "City"
    And   I should see the error "can't be blank" for "State"
    And   I should see the error "can't be blank" for "Zipcode"
    And   I should see the error "is not a valid credit card number" for "Card number"
    And   I should see the error "is not a valid month" for "Month"
    And   I should see the error "expired" for "Year"
    And   I should see the error "can't be blank" for "CVV2"


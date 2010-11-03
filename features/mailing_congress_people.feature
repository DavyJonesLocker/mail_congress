@envjs
Feature: Mailing congress people

  Scenario: Mailing my congress people
    Given I have found my congress people
    When  I write my letter to all of my congress people
    And   I pay for the letters with my credit card
    Then  My letters should be on their way

  Scenario: Selecting then unselecting all legislators
    Given I have found my congress people
    When  I select my congress people
    And   I unselect my congress people
    Then  I should see "$0 no legislators chosen."

  Scenario: Submitting a letter with no legislators selected
    Given I have found my congress people
    When  I write a thank-you letter
    Then  I should see my congress people
    Then  I should see "You must select at least one legislator."

  Scenario: Submitting an empty letter
    Given I have found my congress people
    When  I press "Send"
    Then  I should see the error "can't be blank" for "Body"
    And   I should see the error "can't be blank" for "First name"
    And   I should see the error "can't be blank" for "Last name"

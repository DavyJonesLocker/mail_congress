@envjs
Feature: Mailing congress people

  Scenario: Mailing my congress people
    Given I have found my congress people
    When  I write my letter to all of my congress people
    Then  I should be on the payment page

  Scenario: Selecting then unselecting all legislators
    Given I have found my congress people
    When  I select my congress people
    And   I unselect my congress people
    Then  I should see "Please choose to whom you wish to write"

  Scenario: Submitting a letter with no legislators selected
    Given I have found my congress people
    When  I write a thank-you letter
    When  I press "Send"
    Then  I should see my congress people
    Then  I should see "You must select at least one legislator."

  Scenario: Submitting an empty letter
    Given I have found my congress people
    When  I press "Send"
    Then  I should see the errors for the letter

  Scenario: Persisting legislator choices after failed validation
    Given I have found my congress people
    When  I click on "Sen. John Kerry"
    And   I press "Send"
    Then  Sen. John Kerry should be selected
    And   I should see "$1 to send this letter"

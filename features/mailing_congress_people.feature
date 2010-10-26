Feature: Mailing congress people

  @envjs
  Scenario: Mailing my congress people
    Given I have found my congress people
    When  I write my letter to all of my congress people
    Then  My letters should be on their way

  @envjs
  Scenario: Selecting then unselecting all legislators
    Given I have found my congress people
    When  I select my congress people
    And   I unselect my congress people
    Then  I should see "$0 no legislators chosen."

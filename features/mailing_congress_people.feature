Feature: Mailing congress people

  @envjs
  Scenario: Mailing my congress people
    Given I have found my congress people
    When  I write my letter to all of my congress people
    Then  My letters should be on their way


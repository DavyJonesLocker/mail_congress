@advocacy
Feature: Advocacy groups

  Scenario: Creating an advocacy group
    Given I am on the home page
    When  I follow "Create advocacy group"
    Then  I should see "Please provide details about your group"
    When  I submit the advocacy group details
    Then  I should see "Thank you, we will be in contact shortly"
    And   I should receive an email noting the confirmation process
    Given a clear email queue
    When  my advocacy group is approved
    Then  I should receive an email confirming me

  Scenario: An advocacy group fails validation
    Given I am on the home page
    When  I follow "Create advocacy group"
    When  I press "Submit"
    Then  I should see the advocacy group validation errors

  Scenario: Signing in
    Given I am an approved advocacy group
    When  I sign in
    Then  I should be on my dashboard

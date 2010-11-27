@envjs @campaigns
Feature: Campaigns

  Scenario: Adding my name to a campaign
    Given a campaign exists
    When  I go to the campaign permalink page
    Then  I should see the campaign summary
    And   I submit the address form with my information
    Then  I should see my congress people
    And   I should see the campaign body
    When  I select my congress people
    And   I sign the campaign
    And   I pay for the letters with my credit card
    Then  My letters should be on their way

  Scenario: Creating a campaign
    Given I am signed in
    When  I follow "Create campaign"
    And   I submit new campaign details
    Then  I should see the new campaign

  Scenario: Creating a campaign without providing data
    Given I am signed in
    When  I follow "Create campaign"
    And   I press "Submit"
    Then  I should see the errors for campaign

  Scenario: Creating a campaign that is limited to only senators
    Given I am signed in
    When  I follow "Create campaign"
    And   I submit new campaign details for senators
    And   I go to the campaign permalink page
    And   I submit the address form with my information
    Then  I should not see "Rep. Stephen Lynch"
    But   I should see "Sen. John Kerry"
    And   I should see "Sen. Scott Brown"

  Scenario: Creating a campaign that is limited to only representatives
    Given I am signed in
    When  I follow "Create campaign"
    And   I submit new campaign details for representatives
    And   I go to the campaign permalink page
    And   I submit the address form with my information
    Then  I should not see "Sen. John Kerry"
    And   I should not see "Sen. Scott Brown"
    But   I should see "Rep. Stephen Lynch"

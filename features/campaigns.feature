@campaigns
Feature: Campaigns

  Scenario: Adding my name to a campaign
    Given Resque is clear
    And   a campaign exists
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
    And   I press "Save Campaign"
    Then  I should see the errors for campaign

  Scenario: Creating a campaign that is limited to only federal senators
    Given I am signed in
    When  I follow "Create campaign"
    And   I submit new campaign details for federal senators
    And   I go to the campaign permalink page
    And   I submit the address form with my information
    Then  I should not see "Rep. Stephen Lynch"
    And   I should not see "Sen. John Hart"
    And   I should not see "Rep. Nick Collins"
    But   I should see "Sen. John Kerry"
    And   I should see "Sen. Scott Brown"

  Scenario: Creating a campaign that is limited to only state representatives
    Given I am signed in
    When  I follow "Create campaign"
    And   I submit new campaign details for state representatives
    And   I go to the campaign permalink page
    And   I submit the address form with my information
    Then  I should not see "Sen. John Kerry"
    And   I should not see "Sen. Scott Brown"
    And   I should not see "Rep. Stephen Lynch"
    And   I should not see "Sen. John Hart"
    But   I should see "Rep. Nick Collins"

  Scenario: Editing a campaign
    Given I am an approved advocacy group
    And   I have a campaign
    When  I sign in
    And   I follow "Test Campaign Title"
    And   I follow "Edit"
    When  I update the campaign details
    Then  I should see "Campaign Title 2 has been updated."
    And   I should see the updated campaign details

  Scenario: Editing a campaign with invalid data
    Given I am an approved advocacy group
    And   I have a campaign
    When  I sign in
    And   I follow "Test Campaign Title"
    And   I follow "Edit"
    When  I update the campaign details with invalid data
    Then  I should see the errors for campaign

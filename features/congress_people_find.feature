Feature: Finding Congress People

  Scenario: Viewing the home page
    When  I go to the home page
    Then  I should see "Please enter your home address."

  @brian
  Scenario: Searching for my congress people with a server side geocode lookup
    Given I am on the home page
    When  I submit the address form with my information
    Then  I should see my congress people

  Scenario: Submitting an empty search
    Given I am on the home page
    When  I press "Find"
    Then  I should see "Valid home address is required"

  Scenario: Searching for my congress people from an ambiguous address
    Given I am on the home page
    When  I submit the address form with "14 Upston St #2 Boston, MA"
    Then  I should see "We have found more than one address. Please choose the correct one."
    When  I choose "14 Upton St #2, Boston, MA 02118"
    And   I press "Find"
    Then  I should see "Sen. John Kerry"
    And   I should see "Sen. Scott Brown"
    And   I should see "Rep. Michael Capuano"

  #@envjs
  #Scenario: Searching for my congress people with a client side geocode lookup
    #Given I do not expect a server side geocode lookup
    #And   I am on the home page
    #When  I submit the address form with my information
    #Then  I should see my congress people
    #And   I should not have done a server side geocode lookup

  #Scenario: Searching with an address that returns zero results
    #Given I am on the home page
    #When  I submit the address form with bad information
    #Then  I should see the try again message

  #Scenario: Searching and Google cannot Geocode
    #Given Google geocoder is broken
    #And   I am on the home page
    #When  I submit the address form with my information
    #Then  I should see the try again message

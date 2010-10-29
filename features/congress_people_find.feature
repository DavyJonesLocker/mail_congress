Feature: Finding Congress People

  Scenario: Viewing the home page
    When  I go to the home page
    Then  I should see "Please enter your home address."

  Scenario: Searching for my congress people with a server side geocode lookup
    Given I am on the home page
    When  I submit the address form with my information
    Then  I should see my congress people

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

Feature: Home

  Scenario: Viewing the home page
    When  I go to the home page
    Then  I should see "Please enter your home address."

  Scenario: Searching for my congress people
    Given I am on the home page
    When  I submit the address form with my information
    Then  I should see my congress people

  Scenario: Mailing my congress people
    Given I am on the home page
    When  I submit the address form with my information
    Then  I should see my congress people
    When  I write my letter to all of my congress people
    Then  I should 

  #Scenario: Searching with an address that returns zero results
    #Given I am on the home page
    #When  I submit the address form with bad information
    #Then  I should see the try again message

  #Scenario: Searching and Google cannot Geocode
    #Given Google geocoder is broken
    #And   I am on the home page
    #When  I submit the address form with my information
    #Then  I should see the try again message

When /^I submit the address form with my information$/ do
  When %{I fill in "Please enter your home address." with "714 East 4th St Apt 3, South Boston, MA"}
  When %{I press "Find"}
end

Then /^I should see my congress people$/ do
  Then %{I should see "Please choose to whom you wish to write"}
  Then %{I should see "Sen. John Kerry"}
  Then %{I should see Sen. John Kerry's photo}
  Then %{I should see "Sen. Scott Brown"}
  Then %{I should see Sen. Scott Brown's photo}
  Then %{I should see "Rep. Stephen Lynch"}
  Then %{I should see Rep. Stephen Lynch's photo}
end


When /^I submit the address form with bad information$/ do
  When %{I fill in "Address" with "Africa"}
end

Then /^I should see the try again message$/ do
  Then %{I should be on the home page}
  Then %{I should see "Please try your search again."}
end

Given /^Google geocoder is broken$/ do
  geoloc = mock('GeoLoc')
  geoloc.stubs(:success).returns(false)
  GeoKit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(geoloc)
end

Given /^I have found my congress people$/ do
  Given %{I am on the home page}
  When  %{I submit the address form with my information}
  Then  %{I should see my congress people}
end


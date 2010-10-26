Given /^I do not expect a server side geocode lookup$/ do
  GeoKit::Geocoders::GoogleGeocoder.stubs(:geocode)
end

Then /^I should not have done a server side geocode lookup$/ do
  GeoKit::Geocoders::GoogleGeocoder.should_not have_received(:geocode)
end


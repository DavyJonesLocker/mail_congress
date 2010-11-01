When /^I pay for the letters with my credit card$/ do
  When %{I fill in "Card number" with "4149244372702504"}
  When %{I select "10" from "Month"}
  When %{I select "2015" from "Year"}
  When %{I fill in "CVV2" with "000"}
  When %{I press "Make payment"}
end


When /^I pay for the letters with my credit card$/ do
  When %{I fill in "Card number" with "4111111111111111"}
  When %{I select "Jan 2012" as the "Expires" date}
  When %{I fill in "CVV2" with "123"}
  When %{I press "Make payment"}
end


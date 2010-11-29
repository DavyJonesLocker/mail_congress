When /^I pay for the letters with my credit card$/ do
  Then %{I should see "You will be charged $3 to send 3 letters."}
  When %{I make the payment}
end

When /^I make the payment$/ do
  When %{I fill in "Email" with "john@test.com"}
  When %{I fill in "Card number" with "4149244372702504"}
  When %{I select "10" from "Month"}
  When %{I select "2015" from "Year"}
  When %{I press "Make secure payment"}
end

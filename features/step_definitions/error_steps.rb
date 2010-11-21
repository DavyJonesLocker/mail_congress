Then /^I should see the error "([^"]*)" for "([^"]*)"$/ do |error, locator|
  id = find(:xpath, XPath::HTML.field(locator))['id']
  find(:xpath, "//*[@id='#{id}']/../div[@class='error']").text.should == error
end

Then /^I should see the errors for the letter$/ do
  Then %{I should see the error "can't be blank" for "letter_body"}
  And  %{I should see the error "can't be blank" for "letter_sender_attributes_first_name"}
  And  %{I should see the error "can't be blank" for "letter_sender_attributes_last_name"}
end

Then /^I should see the errors for the payment$/ do
  Then  %{I should see the error "is invalid" for "Email"}
  Then  %{I should see the error "can't be blank" for "First name"}
  Then  %{I should see the error "can't be blank" for "Last name"}
  Then  %{I should see the error "can't be blank" for "Street address"}
  Then  %{I should see the error "can't be blank" for "City"}
  Then  %{I should see the error "can't be blank" for "State"}
  Then  %{I should see the error "can't be blank" for "Zipcode"}
  Then  %{I should see the error "is not a valid credit card number" for "Card number"}
  Then  %{I should see the error "is not a valid month" for "Month"}
  Then  %{I should see the error "expired" for "Year"}
end

When /^I submit feedback$/ do
  When %{I fill in "Email" with "user@test.com"}
  And  %{I fill in "Feedback" with "Test feedback"}
  And  %{I press "Submit"}
end

Then /^my feedback should be sent$/ do
  Then %{"feedback@mailcongress.org" should receive an email}
  When %{I open the email}
  Then %{I should see "user@test.com" in the email body}
  And %{I should see "Test feedback" in the email body}
  
  # flash[:notice] on the home page
  And %{I should see "Thank you for your feedback!"}
end

Then /^I should see errors for the feedback$/ do
  Then  %{I should see the error "can't be blank" for "Email"}
  Then  %{I should see the error "can't be blank" for "Feedback"}
end


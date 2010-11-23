When /^I submit the advocacy group details$/ do
  When %{I fill in "Group name" with "Test group"}
  When %{I fill in "advocacy_group_contact_name" with "John Doe"}
  When %{I fill in "Email" with "test@test.com"}
  When %{I fill in "Phone number" with "555.555.5555"}
  When %{I fill in "Website" with "http://test.com"}
  When %{I fill in "Purpose" with "To mail lots of letters"}
  When %{I fill in "Password" with "12345abcdef"}
  When %{I fill in "Password confirmation" with "12345abcdef"}
  When %{I press "Submit application"}
end

When /^my advocacy group is approved$/ do
  @advocacy_group ||= AdvocacyGroup.last
  @advocacy_group.approve!
end

Then /^I should see the advocacy group validation errors$/ do
  Then %{I should see the error "can't be blank" for "Group name"}
  Then %{I should see the error "can't be blank" for "advocacy_group_contact_name"}
  Then %{I should see the error "can't be blank" for "Email"}
  Then %{I should see the error "can't be blank" for "Website"}
  Then %{I should see the error "is invalid" for "Phone number"}
  Then %{I should see the error "can't be blank" for "Purpose"}
end


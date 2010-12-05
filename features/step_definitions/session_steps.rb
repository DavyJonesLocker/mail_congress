When /^I sign in$/ do
  When %{I am on the home page}
  When %{I follow "Sign in"}
  When %{I fill in "sign_in_email" with "#{@advocacy_group.email}"}
  When %{I fill in "sign_in_password" with "#{@advocacy_group.password}"}
  When %{I press "Sign in"}
end

Given /^I am signed in$/ do
  Given %{I am an approved advocacy group}
  When  %{I sign in}
  Then  %{I should be on my dashboard}
end


When /^I write my letter to all of my congress people$/ do
  When %{I select my congress people}
  And  %{I write then a thank-you letter}
  And  %{I press "Send Letters"}
end

When /^I select my congress people$/ do
  When %{I check "Sen. John Kerry"}
  And  %{I check "Sen. Scott Brown"}
  And  %{I check "Rep. Stephen Lynch"}
end


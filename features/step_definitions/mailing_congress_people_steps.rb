When /^I write my letter to all of my congress people$/ do
  When %{I select my congress people}
  And  %{I write then a thank-you letter}
  And  %{I press "Send Letters"}
end

When /^I select my congress people$/ do
  When %{I check "Sen. John Kerry"}
  # Then %{I should see "$1 to send this letter."}
  When %{I check "Sen. Scott Brown"}
  # Then %{I should see "$2 to send these letters."}
  When %{I check "Rep. Stephen Lynch"}
  # Then %{I should see "$3 to send these letters."}
end


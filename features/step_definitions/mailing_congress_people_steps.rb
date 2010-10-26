When /^I write my letter to all of my congress people$/ do
  When %{I select my congress people}
  And  %{I write them a thank-you letter}
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

When /^I write them a thank\-you letter$/ do
  When %{I fill in "Email" with "john@doe.com"}
  When %{I fill in "First name" with "John"}
  When %{I fill in "Last name" with "Doe"}
  letter = <<-LETTER
Dear [rep name],
  I just wanted to thank you for your service.

  Yours,
    [my name]
LETTER
  fill_in('Body', :with => letter)
  When %{I press "Send"}
end

Then /^My letters should be on their way$/ do
  Then %{I should see "Your letters are now being processed."}
  Then %{I should see "We will notify you when they arrive."}
end


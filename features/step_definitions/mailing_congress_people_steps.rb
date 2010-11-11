When /^I write my letter to all of my congress people$/ do
  When %{I select my congress people}
  And  %{I write them a thank-you letter}
  When %{I press "Send"}
end

When /^I select my congress people$/ do
  Then %{I should see "$0 no legislators chosen."}
  When %{I click the label "Sen. John Kerry"}
  Then %{I should see "$1 to send this letter."}
  Then %{legislator K000148 should be selected}
  When %{I click the label "Sen. Scott Brown"}
  Then %{I should see "$2 to send these letters."}
  Then %{legislator B001268 should be selected}
  When %{I click the label "Rep. Stephen Lynch"}
  Then %{I should see "$3 to send these letters."}
  Then %{legislator L000562 should be selected}
end

When /^I unselect my congress people$/ do
  Then %{I should see "$3 to send these letters."}
  When %{I click the label "Sen. John Kerry"}
  Then %{I should see "$2 to send these letters."}
  When %{I click the label "Sen. Scott Brown"}
  Then %{I should see "$1 to send this letter."}
  When %{I click the label "Rep. Stephen Lynch"}
  Then %{I should see "$0 no legislators chosen."}
end

When /^I write (?:|him |her |them )a thank\-you letter$/ do
  When %{I fill in "First name" with "John"}
  When %{I fill in "Last name" with "Doe"}
  When %{I fill in "Body" with "I just wanted to thank you for your service."}
end

When /^I click the label "([^"]*)"$/ do |text|
  evaluate_script(<<-JS)
    $('label').each(function() { if($(this).text() == "#{text}") { $(this).trigger('click'); } })
  JS
end

When /^I should see the mail icon for (\w+)$/ do |bioguide|
  find("li##{bioguide} .mail").visible?.should be_true
end

Then /^My letters should be on their way$/ do
  Then %{the letter has print queued}
  Then %{I should see "Your letters are now being processed."}
  Then %{I should see "We will notify you when they arrive."}
end

Then /^legislator (\w+) should be selected$/ do |bioguide_id|
  find(:css, "li##{bioguide_id} div.bioguide")[:class].should include('color')
end


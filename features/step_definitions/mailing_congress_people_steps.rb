Given /^I have mailed (\d+) legislators?$/ do |number|
  Given %{I am on the home page}
  And   %{I have found my congress people}
  legislators = all(:css, 'ul.legislators li label')
  (1..number.to_i).each do |i|
    When %{I click on "#{legislators[i-1].text}"}
  end
  When %{I write them a thank-you letter}
  And  %{I press "Send"}
  And  %{I make the payment}
end

When /^I write my letter to all of my congress people$/ do
  When %{I select my congress people}
  And  %{I write them a thank-you letter}
  When %{I press "Send"}
end

When /^I select my congress people$/ do
  When %{I click on "Sen. John Kerry"}
  Then %{I should see "$1 to send this letter"}
  Then %{Sen. John Kerry should be selected}
  When %{I click on "Sen. Scott Brown"}
  Then %{I should see "$2 to send these letters"}
  Then %{Sen. Scott Brown should be selected}
  When %{I click on "Rep. Stephen Lynch"}
  Then %{I should see "$3 to send these letters"}
  Then %{Rep. Stephen Lynch should be selected}
end

When /^I unselect my congress people$/ do
  Then %{I should see "$3 to send these letters"}
  When %{I click on "Sen. John Kerry"}
  Then %{I should see "$2 to send these letters"}
  When %{I click on "Sen. Scott Brown"}
  Then %{I should see "$1 to send this letter"}
  When %{I click on "Rep. Stephen Lynch"}
end

When /^I write (?:|him |her |them )a thank\-you letter$/ do
  When %{I sign my name}
  When %{I fill in "Dear Legislator," with "I just wanted to thank you for your service."}
end

When /^I sign my name$/ do
  When %{I fill in "letter_sender_attributes_first_name" with "John"}
  When %{I fill in "letter_sender_attributes_last_name" with "Doe"}
end

When /^I click on "([^"]*)"$/ do |name|
  evaluate_script(<<-JS)
    $('li##{get_li_from_name(name)['id']}').trigger('click');
  JS
end

When /^I should see the mail icon for (\w+)$/ do |bioguide|
  find("li##{bioguide} .mail").visible?.should be_true
end

Then /^My letters should be on their way$/ do
  Then %{the letter has print queued}
  Then %{I should see "Thank you for Mailing Congress."}
  Then %{I should see "We will notify you when your letters have been printed & mailed."}
end

Then /^(.+) should be selected$/ do |name|
  get_li_from_name(name).find(:css, 'div.bioguide')[:class].should include('color')
end

def get_li_from_name(name)
  find(:xpath, "//label[text()='#{name}']/..")
end


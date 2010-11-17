Then /^I should receive the print confirmation email$/ do
  email = Sender.last.email
  Then %{"#{email}" should receive an email}
  When %{I open the email}
  Then %{I should see "Your letter has finished printing and is ready to ship." in the email subject}
  And  %{I should see "You will be notified when it arrives." in the email body}
end


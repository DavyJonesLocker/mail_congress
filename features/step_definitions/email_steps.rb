Then /^I should receive the print confirmation email$/ do
  email = Sender.last.email
  Then %{"#{email}" should receive an email}
  When %{I open the email}
  Then %{I should see "[MailCongress] Your letter has finished printing and is ready to ship." in the email subject}
  And  %{I should see "You will be notified when it arrives." in the email body}
end

Then /^I should receive an email noting the confirmation process$/ do
  @advocacy_group ||= AdvocacyGroup.last
  Then %{"#{@advocacy_group.email}" should receive an email}
  When %{I open the email}
  Then %{I should see "[MailCongress] We have received your application." in the email subject}
end

Then /^I should receive an email confirming me$/ do
  @advocacy_group ||= AdvocacyGroup.last
  Then %{"#{@advocacy_group.email}" should receive an email}
  When %{I open the email}
  Then %{I should see "[MailCongress] Your group has been approved!" in the email subject}
end

Then /^I should receive a notification email (\d+) days later$/ do |days|
  Given %{a clear email queue}
  email = Sender.last.email
  When  %{#{days} days pass}
  When  %{the scheduled jobs have been processed}
  Then  %{"#{email}" should receive an email}
  When  %{I open the email}
  Then  %{I should see "[MailCongress] Your letter has arrived." in the email subject}
end


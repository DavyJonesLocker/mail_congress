When /^I make a follow up phone call$/ do
  visit(current_email.default_part_body.to_s.match(/https?:\/\/\S+\/follow_ups\/\S+/)[0])
  letter = Letter.last
  letter.recipients.each do |recipient|
    Then %{I should see "#{recipient.legislator.name}"}
    Then %{I should see "#{recipient.legislator.phone}"}
  end
end


Then /^I should see the campaign$/ do
  @campaign ||= Campaign.last
  Then %{I should see "#{@campaign.title}"}
  lines = @campaign.body.split("\n")
  lines.each do |line|
    Then %{I should see "#{line}"}
  end
end

When /^I sign the campaign$/ do
  When %{I sign my name}
  When %{I press "Send"}
end


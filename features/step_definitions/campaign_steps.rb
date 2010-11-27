Then /^I should see the campaign summary$/ do
  @campaign ||= Campaign.last
  Then %{I should see "#{@campaign.title}"}
  lines = @campaign.summary.split("\n")
  lines.each do |line|
    Then %{I should see "#{line}"}
  end
end

Then /^I should see the campaign body$/ do
  @campaign ||= Campaign.last
  lines = @campaign.body.split("\n")
  lines.each do |line|
    Then %{I should see "#{line}"}
  end
end

When /^I sign the campaign$/ do
  When %{I sign my name}
  When %{I press "Send"}
end

When /^I submit new campaign details for (\w+)$/ do |title|
  When %{I choose "#{title.capitalize}"}
  When %{I submit new campaign details}
end

When /^I submit new campaign details$/ do
  When %{I fill in "Title" with "Campaign Title"}
  When %{I fill in "Summary" with "Campaign Summary"}
  When %{I fill in "Body" with "Campaign Body"}
  When %{I press "Submit"}
end

Then /^I should see the new campaign$/ do
  Then %{I should see "Campaign Title"}
  Then %{I should see "Campaign Summary"}
  Then %{I should see "Campaign Body"}
  Then %{I should see the campaign permalink}
end

Then /^I should see the campaign permalink$/ do
  @campaign ||= Campaign.last
  Then %{I should see "#{campaign_permalink_url(@campaign, :protocol => 'https')}"}
end

Given /^I have a campaign$/ do
  @advocacy_group ||= AdvocacyGroup.last
  @campaign = Factory(:campaign, :advocacy_group => @advocacy_group)
end

When /^I update the campaign details$/ do
  When %{I fill in "Title" with "Campaign Title 2"}
  When %{I fill in "Summary" with "Campaign Summary 2"}
  When %{I fill in "Body" with "Campaign Body 2"}
  When %{I press "Submit"}
end

When /^I update the campaign details with invalid data$/ do
  When %{I fill in "Title" with ""}
  When %{I fill in "Summary" with ""}
  When %{I fill in "Body" with ""}
  When %{I press "Submit"}
end

Then /^I should see the updated campaign details$/ do
  Then %{I should see "Campaign Title 2"}
  Then %{I should see "Campaign Summary 2"}
  Then %{I should see "Campaign Body 2"}
  Then %{I should see the campaign permalink}
end


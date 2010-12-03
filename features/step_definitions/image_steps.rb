Then /^I should see the letter as an image$/ do
  find('#letter_preview').should have_selector('img')
end

Then /^I should see (.+)'s photo$/ do |name|
  page.find("div[style=\"background-image:url(\'/images/bioguides/#{get_li_from_name(name)['id']}.jpg\')\"]").should_not be_nil
end

Then /^I should see the letter as an image$/ do
  find('#letter_preview').should have_selector('img')
end

Then /^I should see bioguide image "([^"]*)"$/ do |image_id|
  page.find("div[style=\"background:url(\'/images/bioguides/#{image_id}.jpg\')\"]").should_not be_nil
end

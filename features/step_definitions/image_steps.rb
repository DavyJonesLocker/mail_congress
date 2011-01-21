Then /^I should see the letter as an image$/ do
  find('#letter_preview').should have_selector('img')
end

Then /^I should see (.+)'s? photo$/ do |name|
  li         = get_li_from_name(name)
  level      = page.find(:xpath, "#{li.path}/..")[:class].split.last
  image_path = "/images/bioguides/#{level}/#{li['id']}.jpg"

  if level == 'federal'
    page.find(%{div[style="background-image:url(\'#{image_path}\')"]}).should_not be_nil
  elsif level == 'state'
    page.find(:xpath, %{//img/@src[contains(text(),#{image_path})]})
  end
end

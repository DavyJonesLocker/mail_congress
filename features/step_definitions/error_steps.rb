Then /^I should see the error "([^"]*)" for "([^"]*)"$/ do |error, locator|
  id = find(:xpath, XPath::HTML.field(locator))['id']
  find(:xpath, "//*[@id='#{id}']/../div[@class='error']").text.should == error
end


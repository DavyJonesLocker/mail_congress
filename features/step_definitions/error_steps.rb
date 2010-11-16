Then /^I should see the error "([^"]*)" for "([^"]*)"$/ do |error, label_text|
  id = find(:xpath, XPath::HTML.fillable_field(label_text))['id']
  find(:xpath, "//*[@id='#{id}']/../span[@class='error']").text.should == error
end


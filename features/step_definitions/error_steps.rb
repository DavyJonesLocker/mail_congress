Then /^I should see the error "([^"]*)" for "([^"]*)"$/ do |error, label_text|
  find(:xpath, "//label[contains(child::text(), '#{label_text}')]/../span[@class='error']").text.should == error
end


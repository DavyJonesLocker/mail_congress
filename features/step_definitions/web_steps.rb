When /^I click "([^"]*)"$/ do |text|
  id = find("*[text()='#{text}']")['id']
  evaluate_script(<<-JS)
    $("##{id}").trigger('click');
  JS
end


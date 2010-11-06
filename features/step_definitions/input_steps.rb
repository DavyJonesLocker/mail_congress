When /^I clear all of the fields$/ do
  all(:css, 'input[type="text"]').each { |input| input.set('') }
end


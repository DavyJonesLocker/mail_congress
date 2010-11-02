Then /^the letter should be marked as printed$/ do
  letter = Letter.last
  letter.should be_printed
end


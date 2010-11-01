Then /the letter has print queued/ do
  letter = Letter.last
  Letter.should have_queued(letter.id, :print)
end

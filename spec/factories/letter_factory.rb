Factory.define :letter do |letter|
  letter.body       { "You're great!" }
  letter.recipients { [Recipient.new(:legislator => Legislator.first)] }
  letter.sender     { Factory(:sender) }
end

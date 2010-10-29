Factory.define :letter do |l|
  l.name_first { "John" }
  l.name_last  { "Doe" }
  l.street     { "123 Test St" }
  l.city       { "Smallville" }
  l.state      { "KS" }
  l.zip        { "12345" }
  l.body       { "You're great!" }
  l.recipients { [Recipient.new(:legislator => Legislator.first)] }
end

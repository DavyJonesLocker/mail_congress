Factory.define :letter do |l|
  l.body       { "You're great!" }
  l.recipients { [Recipient.new(:legislator => Legislator.first)] }
end

Factory.define :letter do |letter|
  letter.body        { "You're great!" }
  letter.recipients  { [Recipient.new(:legislator => Legislator.first)] }
  letter.sender      { Factory(:sender) }
  letter.after_build { |letter_instance| letter_instance.generate_follow_up_id! }
end

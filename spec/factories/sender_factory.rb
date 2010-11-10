Factory.sequence(:email) { |n| "user_#{n}@test.com" }

Factory.define :sender do |sender|
  sender.email      { Factory.next(:email) }
  sender.first_name { "John" }
  sender.last_name  { "Doe" }
  sender.street     { "123 Test St." }
  sender.city       { "Smallville" }
  sender.state      { "KS" }
  sender.zip        { "12345" }
end

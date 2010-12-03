Factory.define :advocacy_group do |advocacy_group|
  advocacy_group.name                  { 'Test Group' }
  advocacy_group.contact_name          { 'John Doe' }
  advocacy_group.email                 {  Factory.next(:email) }
  advocacy_group.phone_number          { '555.555.5555' }
  advocacy_group.website               { 'http://www.testsite.com' }
  advocacy_group.purpose               { 'To send letters' }
  advocacy_group.password              { '12345abcdef' }
  advocacy_group.password_confirmation { '12345abcdef' }
end

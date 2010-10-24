class Letter < ActiveRecord::Base
  has_many :recipient_legislators
  has_many :recipients, :through => :recipient_legislators, :source => :legislator
  accepts_nested_attributes_for :recipients, :allow_destroy => true
end

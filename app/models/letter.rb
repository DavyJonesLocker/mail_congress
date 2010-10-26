class Letter < ActiveRecord::Base
  has_many :recipients
  has_many :legislators, :through => :recipients
  accepts_nested_attributes_for :recipients, :allow_destroy => true
end

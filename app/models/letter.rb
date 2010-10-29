class Letter < ActiveRecord::Base
  @queue = :letters

  has_many :recipients
  has_many :legislators, :through => :recipients
  accepts_nested_attributes_for :recipients, :allow_destroy => true

  def self.perform
    puts "hey"
  end 
end

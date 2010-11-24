class Campaign < ActiveRecord::Base
  has_many :letters

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :body
end

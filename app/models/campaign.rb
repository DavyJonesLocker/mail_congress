class Campaign < ActiveRecord::Base
  self.inheritance_column = 'other_type'
  has_many   :letters
  belongs_to :advocacy_group

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :body
end

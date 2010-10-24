class RecipientLegislator < ActiveRecord::Base
  belongs_to :letter
  belongs_to :legislator
end

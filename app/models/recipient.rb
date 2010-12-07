class Recipient < ActiveRecord::Base
  belongs_to :letter
  belongs_to :legislator

  # place holder for failed server side validations
  attr_accessor    :selected
  attr_accessible  :selected, :legislator, :legislator_id
  alias :selected? :selected

  def css_class
    self.selected? ? 'color' : 'monochrome'
  end

  def to_hash
    {:legislator_id => legislator_id}
  end
end

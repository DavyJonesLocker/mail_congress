class Recipient< ActiveRecord::Base
  belongs_to :letter
  belongs_to :legislator

  # place holder for failed server side validations
  attr_accessor :selected
  alias :selected? :selected

  def css_class
    self.selected? ? 'color' : 'monochrome'
  end
end

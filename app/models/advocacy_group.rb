class AdvocacyGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :contact_name
  validates_presence_of :website
  validates_format_of :phone_number, :with => /^(1\W?)?(\([2-9]\d{2}\)|[2-9]\d{2})\W?[2-9]\d{2}\W?\d{4}$/
  validates_presence_of :purpose

  devise :database_authenticatable, :validatable
  attr_accessible :email, :password, :password_confirmation, :name, :contact_name, :phone_number, :website, :purpose

  def approve!
    self.update_attribute(:approved, true)
    AdvocacyGroupMailer.approval_confirmation(self).deliver
  end
end

class Sender < ActiveRecord::Base
  has_many :letters
  validates_presence_of :first_name, :last_name
  validates_presence_of :street, :city, :state, :zip
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :allow_nil => true
  validates_format_of :first_name, :with => /^(?!First name|Last name).*/, :message => "can't be blank"
  validates_format_of :last_name, :with => /^(?!First name|Last name).*/, :message => "can't be blank"

  attr_accessible :first_name, :last_name, :email, :street, :city, :state, :zip
  
  def build_payment
    Payment.new(
      :credit_card => {
        :first_name => first_name,
        :last_name  => last_name
      },
      :street => street,
      :city   => city,
      :state  => state,
      :zip    => zip
    )
  end

  def envelope_text
    "#{name}\n#{street}\n#{city}, #{state} #{zip}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  def first_name=(first_name)
    super(first_name.nil? ? nil : first_name.capitalize)
  end

  def last_name=(last_name)
    super(last_name.nil? ? nil : last_name.capitalize)
  end
end

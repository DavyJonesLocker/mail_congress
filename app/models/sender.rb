class Sender < ActiveRecord::Base
  has_many :letters
  validates_presence_of :first_name, :last_name
  validates_presence_of :street, :city, :state, :zip
  validates_presence_of :email, :unless => Proc.new { |sender| sender.email.nil? }
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  
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
    "#{first_name} #{last_name}\n#{street}\n#{city}, #{state} #{zip}"
  end

  def name
    "#{first_name} #{last_name}"
  end
end

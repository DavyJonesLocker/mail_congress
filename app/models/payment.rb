class Payment
  include ActiveModel::Validations
  
  attr_accessor :number, :month, :year, :verification_value

  attr_accessor :first_name, :last_name
  attr_accessor :street, :city, :state, :zip

  attr_accessor :gateway, :credit_card

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def to_key
    nil
  end

  def make(number, extra_options)
    self.gateway = ActiveMerchant::Billing::PaypalGateway.new(paypal_credentials)
    self.credit_card = ActiveMerchant::Billing::CreditCard.new(
      :number             => self.number,
      :month              => self.month,
      :year               => self.year,
      :verification_value => self.verification_value,
      :first_name         => self.first_name,
      :last_name          => self.last_name
    )
    response = gateway.purchase(100 * number, credit_card, options(extra_options))
    response.success?
  end

  def paypal_credentials
    file = File.open("#{Rails.root}/config/paypal/#{Rails.env}.yml")
    YAML.load(file)
  end

  def options(extras)
    {
      :billing_address => {
        :name      => "#{self.first_name} #{self.last_name}",
        :address_1 => self.street,
        :city      => self.city,
        :state     => self.state,
        :zip       => self.zip,
        :country   => 'US'
      }
    }.merge(extras)
  end

end

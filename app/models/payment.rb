class Payment
  class AssociatedValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return if (value.is_a?(Array) ? value : [value]).collect{ |r| r.nil? || r.valid? }.all?
      record.errors.add(attribute, :invalid, options.merge(:value => value))
    end
  end

  def self.validates_associated(*attr_names)
    validates_with AssociatedValidator, _merge_attributes(attr_names)
  end
  
  include ActiveModel::Validations
  
  attr_accessor :street, :city, :state, :zip
  attr_accessor :gateway, :credit_card

  validates_presence_of :street, :city, :state, :zip
  validates_associated  :credit_card

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def credit_card=(attributes={})
    @credit_card = CreditCard.new(attributes)
  end

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def to_key
    nil
  end

  def make(number, extra_options)
    self.gateway = ActiveMerchant::Billing::PaypalGateway.new(paypal_credentials)
    if self.valid?
      response = gateway.purchase(100 * number, credit_card, options(extra_options))
      response.success?
    else
      false
    end
  end

  def paypal_credentials
    file = File.open("#{Rails.root}/config/paypal/#{Rails.env}.yml")
    YAML.load(file)
  end

  def options(extras)
    {
      :billing_address => {
        :name      => "#{self.credit_card.name}",
        :address_1 => self.street,
        :city      => self.city,
        :state     => self.state,
        :zip       => self.zip,
        :country   => 'US'
      }
    }.merge(extras)
  end

end

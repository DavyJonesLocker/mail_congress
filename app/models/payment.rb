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
  attr_accessor :type, :url, :redis_key

  validates_presence_of :street, :city, :state, :zip, :unless => Proc.new { |payment| payment.type == 'paypal' }
  validates_associated  :credit_card, :unless => Proc.new { |payment| payment.type == 'paypal' }

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

  def make(letter, extra_options)
    self.type = letter.payment_type
    valid = letter.valid?
    valid = valid? && valid
    return false unless valid

    if type == 'paypal'
      with_paypal(letter, extra_options)
    else
      with_credit_card(letter, extra_options)
    end
  end

  def self.complete(cost, attrs = {})
    gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_credentials)
    gateway.purchase(cost, attrs)
  end

  def self.paypal_credentials
    file = File.open("#{Rails.root}/config/paypal/#{Rails.env}.yml")
    YAML.load(file)
  end

  def paypal_credentials
    self.class.paypal_credentials
  end

  def options(extras)
    if type == 'paypal'
      paypal_options(extras)
    else
      credit_card_options(extras)
    end
  end

  private

  def credit_card_options(extras)
    {
      :billing_address => {
        :name      => "#{self.credit_card.name}",
        :address_1 => self.street,
        :city      => self.city,
        :state     => self.state,
        :zip       => self.zip,
        :country   => 'US'
      }
    }.merge(:email => extras[:email], :ip => extras[:ip])
  end

  def paypal_options(extras)
    {
      :ip                => extras[:ip],
      :return_url        => "#{extras[:payments_url]}complete/#{redis_key}",
      :cancel_return_url => "#{extras[:payments_url]}cancel/#{redis_key}"
    }
  end

  def with_credit_card(letter, extra_options)
    extra_options.merge!(:email => letter.sender.email)
    self.gateway = ActiveMerchant::Billing::PaypalGateway.new(paypal_credentials)
    response     = gateway.purchase(letter.cost, credit_card, options(extra_options))
    if response.success?
      true
    else
      self.errors.add(:gateway, 'payment authorization failed')
      false
    end
  end

  def with_paypal(letter, extra_options)
    self.redis_key  = letter.to_redis!
    self.gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_credentials)
    response     = gateway.setup_purchase(letter.cost, paypal_options(extra_options))

    if response.success?
      self.url = gateway.redirect_url_for(response.token)
      true
    else
      self.errors.add(:gateway, 'no response from Paypal')
      false
    end
  end

end

# Heavily borrowed from ActiveMerchant::Biling::CreditCard
# Updated for ActiveModel::Validations

class CreditCard
  include ActiveMerchant::Billing::CreditCardMethods
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Naming
  
  ## Attributes
  
  cattr_accessor :require_verification_value
  self.require_verification_value = true
  
  # Essential attributes for a valid, non-bogus creditcards
  attr_accessor :number, :month, :year, :type
  
  attr_accessor :first_name, :last_name
  validates_presence_of :first_name, :last_name
  
  # Required for Switch / Solo cards
  attr_accessor :start_month, :start_year, :issue_number

  # Optional verification_value (CVV, CVV2 etc). Gateways will try their best to 
  # run validation on the passed in value if it is supplied
  attr_accessor :verification_value
  validates_presence_of :verification_value, :if => :requires_verification_value?

  def initialize(attributes = {})
    attributes.each do |method, value|
      self.send("#{method}=", value)
    end
  end

  # Provides proxy access to an expiry date object
  def expiry_date
    ActiveMerchant::Billing::CreditCard::ExpiryDate.new(@month, @year)
  end

  def expired?
    expiry_date.expired?
  end
  
  def name
    "#{@first_name} #{@last_name}"
  end
        
  # Show the card number, with all but last 4 numbers replace with "X". (XXXX-XXXX-XXXX-4338)
  def display_number
    self.class.mask(number)
  end
  
  def last_digits
    self.class.last_digits(number)
  end
  
  validate :validate_essential_attributes
  validate :validate_card_type
  validate :validate_card_number
  validate :validate_switch_or_solo_attributes
 
  before_validation :sanitize_attributes

  def requires_verification_value?
    self.class.require_verification_value
  end
  
  private
  
  def sanitize_attributes #:nodoc:
    self.month = month.to_i
    self.year  = year.to_i
    self.start_month = start_month.to_i unless start_month.nil?
    self.start_year = start_year.to_i unless start_year.nil?
    self.number = number.to_s.gsub(/[^\d]/, "")
    self.type.downcase! if type.respond_to?(:downcase)
    self.type = self.class.type?(number) if type.blank?
  end
  
  def validate_card_number #:nodoc:
    errors.add :number, "is not a valid credit card number" unless CreditCard.valid_number?(number)
    if errors[:number].empty? && errors[:type].empty?
      errors.add :type, "is not the correct card type" unless CreditCard.matching_type?(number, type)
    end
  end
  
  def validate_card_type #:nodoc:
    errors.add :type, "is required" if type.blank?
    errors.add :type, "is invalid"  unless CreditCard.card_companies.keys.include?(type)
  end
  
  def validate_essential_attributes #:nodoc:
    errors.add :month,      "is not a valid month" unless valid_month?(@month)
    errors.add :year,       "expired"              if expired?
    errors.add :year,       "is not a valid year"  unless valid_expiry_year?(@year)
  end
  
  def validate_switch_or_solo_attributes #:nodoc:
    if %w[switch solo].include?(type)
      unless valid_month?(@start_month) && valid_start_year?(@start_year) || valid_issue_number?(@issue_number)
        errors.add :start_month,  "is invalid"      unless valid_month?(@start_month)
        errors.add :start_year,   "is invalid"      unless valid_start_year?(@start_year)
        errors.add :issue_number, "cannot be empty" unless valid_issue_number?(@issue_number)
      end
    end
  end
  
end


class Payment
  include ActiveModel::Validations
  
  attr_accessor :acct, :expdate, :cvv2
  attr_accessor :amt, :itemamnt, :taxamt

  attr_accessor :firstname, :lastname
  attr_accessor :street, :city, :state, :zip

  def initialize(attrs = {})
    attrs.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def to_key
    nil
  end
end

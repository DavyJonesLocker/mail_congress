class Feedback
  include ActiveModel::Validations

  attr_accessor :email, :body

  validates_presence_of :email, :body

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def mail
    SenderMailer.feedback(self).deliver
  end

  def to_key
    nil
  end

  def persisted?
    false
  end
end

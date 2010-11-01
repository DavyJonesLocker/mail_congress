class Letter < ActiveRecord::Base
  @queue = "letters_#{Rails.env}".to_sym
  
  has_many :recipients
  has_many :legislators, :through => :recipients
  accepts_nested_attributes_for :recipients, :allow_destroy => true

  def build_payment
    Payment.new(
      :first_name => name_first,
      :last_name  => name_last,
      :street     => street,
      :city       => city,
      :state      => state,
      :zip        => zip
    )
  end

  def enqueue_print_job
    Resque.enqueue(Letter, self.id, :print)
  end
end

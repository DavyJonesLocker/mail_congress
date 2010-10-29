class Letter < ActiveRecord::Base

  has_many :recipients
  has_many :legislators, :through => :recipients
  accepts_nested_attributes_for :recipients, :allow_destroy => true

  def build_payment
    Payment.new(
      :firstname => name_first,
      :lastname  => name_last,
      :street    => street,
      :city      => city,
      :state     => state,
      :zip       => zip
    )
  end
end

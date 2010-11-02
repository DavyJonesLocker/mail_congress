class Letter < ActiveRecord::Base
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

  def to_pdf
    Prawn::Document.new do |pdf|
      self.legislators.each do |legislator|
        pdf.text self.body
        pdf.start_new_page
        pdf.text legislator.name
        pdf.start_new_page unless self.legislators.last == legislator
      end
    end.render
  end

end

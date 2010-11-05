class Letter < ActiveRecord::Base
  has_many :recipients
  has_many :legislators, :through => :recipients
  accepts_nested_attributes_for :recipients, :allow_destroy => true

  validates_presence_of :name_first, :name_last
  validates_presence_of :street, :city, :state, :zip
  validates_presence_of :body
  
  validate :presence_of_recipients

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

  def build_recipients(geoloc)
    self.recipients.each { |recipient| recipient.selected = true }
    selected_legislator_ids = self.recipients.map { |recipient| recipient.legislator_id }

    self.recipients = Legislator.search(geoloc).map do |legislator|
      Recipient.new(:legislator => legislator, :selected => selected_legislator_ids.include?(legislator.id))
    end
  end

  private

  def presence_of_recipients
    if recipients.empty?
      self.errors.add(:recipients, "You must select at least one legislator.")
    end
  end

end

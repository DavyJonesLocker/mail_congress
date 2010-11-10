class Letter < ActiveRecord::Base
  has_many   :recipients
  has_many   :legislators, :through => :recipients
  belongs_to :sender
  accepts_nested_attributes_for :recipients, :allow_destroy => true
  accepts_nested_attributes_for :sender

  validates_presence_of :body
  
  validate :presence_of_recipients
  validate :fit_letter_on_one_page

  attr_accessor :font_size
  attr_accessor :min_font_size

  def initialize(attributes = nil)
    self.font_size     = 12.0
    self.min_font_size = 6.5
    super
  end

  def to_pdf
    fit_letter_on_one_page

    Prawn::Document.new do |pdf|
      pdf.font_size self.font_size
      self.legislators.each do |legislator|
        pdf.text self.body
        pdf.start_new_page
        pdf.text_box sender.envelope_text, 
          :at => [pdf.bounds.left, pdf.bounds.top * 0.65]
        pdf.text_box legislator.envelope_text,
          :at => [pdf.bounds.left * 0.3, pdf.bounds.top * 0.5], :align => :center
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

  def sender_attributes=(attributes = nil)
    if sender = Sender.find_by_email(attributes[:email])
      attributes['id'] = sender.id
      self.sender_id   = sender.id
    end
    assign_nested_attributes_for_one_to_one_association(:sender, attributes)
  end

  private

  def presence_of_recipients
    if recipients.empty?
      self.errors.add(:recipients, "You must select at least one legislator.")
    end
  end

  def fit_letter_on_one_page
    document = Prawn::Document.new
    text     = "\n\n#{body}\n\n\n"
    loop do
      box = Prawn::Text::Box.new(text, :width => document.bounds.width, :height => document.bounds.height, :document => document, :size => font_size)
      if box.render == ""
        break
      else
        self.font_size -= 0.5
        if font_size < min_font_size
          font_size = min_font_size
          errors.add(:body, 'The letter is too long to fit on one page.')
          break
        end
      end
    end
  end

end

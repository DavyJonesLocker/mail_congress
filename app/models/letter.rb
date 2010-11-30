class Letter < ActiveRecord::Base
  @queue = :letter

  has_many   :recipients
  has_many   :legislators, :through => :recipients
  belongs_to :sender
  belongs_to :campaign
  accepts_nested_attributes_for :recipients, :allow_destroy => true
  accepts_nested_attributes_for :sender

  validates_presence_of :body #, :unless => Proc.new { |letter| letter.campaign }
  
  validate :presence_of_recipients
  validate :fit_letter_on_one_page

  attr_accessor   :font_size
  attr_accessor   :min_font_size
  attr_accessible :body, :printed, :sender_attributes, :recipients_attributes, :campaign_id, :campaign

  def self.perform(id, method)
    letter = Letter.find(id)
    letter.send(method)
  end

  def generate_follow_up_id!
    self.follow_up_id = Digest::MD5.hexdigest "#{sender.email}-#{DateTime.now}"
  end

  def delivery_notification
    SenderMailer.delivery_notification(self).deliver
  end

  def body
    if campaign
      if attributes["body"] == 'Please add an optional personal message here.'
        campaign.body
      else
        "#{campaign.body}\n\n#{super}"
      end
    else
      super
    end
  end

  def to_pdf
    fit_letter_on_one_page

    Prawn::Document.new do |pdf|
      self.legislators.each do |legislator|
        pdf.font_size self.font_size
        pdf.text "#{legislator.name},", :leading => font_size
        pdf.text self.body, :indent_paragraphs => font_size
        pdf.text "Your constituent,\n#{sender.envelope_text}", :align => :right
        pdf.start_new_page
        pdf.font_size 12
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

    self.recipients = Legislator.send(search_type, geoloc).map do |legislator|
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

  def to_png
    fit_letter_on_one_page
    document = Prawn::Document.new do |pdf|
      pdf.font_size self.font_size
      pdf.text "[Legislator's name will go here on the printed letter],", :leading => font_size
      pdf.text self.body, :indent_paragraphs => font_size
      pdf.text "Your constituent,\n#{sender.envelope_text}", :align => :right
    end
    file_name  = "#{Digest::SHA1.hexdigest("#{body}-#{sender.name}-#{Time.now}")}.png"
    base64     = Base64.encode64(document.render)
    images     = ::Magick::Image.read_inline(base64)
    image_list = ::Magick::ImageList.new
    images.map  { |image| image_list.push(image.extent(image.columns, image.rows + 5)) }
    image_list.append(true).write("#{Rails.root}/public/images/tmp/#{file_name}")
    file_name
  end

  private

  def search_type
    type = 'search'

    if campaign
      unless campaign.type.empty? || campaign.type == 'both'
        type = "#{type}_#{campaign.type.pluralize}"
      end
    end
    type
  end

  def presence_of_recipients
    if recipients.empty?
      self.errors.add(:recipients, "You must select at least one legislator.")
    end
  end

  def fit_letter_on_one_page
    self.font_size     = 12.0
    self.min_font_size = 7

    document = Prawn::Document.new
    text     = "Dear Legislator,\n#{body}\nYour constituent,\nJohn Doe\n123 Fake St.\nSpringfield, XX 012345"
    box      = nil
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

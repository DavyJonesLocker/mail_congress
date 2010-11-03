require 'spec_helper'

describe Letter do
  it { should have_many :recipients }
  it { should have_many :legislators, :through => :recipients }
  it { should accept_nested_attributes_for :recipients }
  it { should validate_presence_of :name_first, :name_last }
  it { should validate_presence_of :street, :city, :state, :zip }
  it { should validate_presence_of :body }

  describe 'validate there is at least 1 recipient' do
    before do
      @letter_without_recipients = Letter.new
      @letter_without_recipients.valid?
      @letter_with_recipients    = Letter.new(:recipients => [Recipient.new])
      @letter_with_recipients.valid?
    end

    it 'should be invalid when there are no recipients' do
      @letter_without_recipients.errors[:recipients].should include("You must select at least one legislator.")
    end
  end

  describe '#build_payment' do
    before do
      @letter  = Factory.build(:letter)
      @payment = @letter.build_payment
    end

    it 'builds a new instance of Payment copying the proper values' do
      @payment.should be_instance_of(Payment)
      @payment.first_name.should == @letter.name_first
      @payment.last_name.should  == @letter.name_last
      @payment.street.should     == @letter.street
      @payment.city.should       == @letter.city
      @payment.state.should      == @letter.state
      @payment.zip.should        == @letter.zip
    end
  end

  describe '#to_pdf' do
    before do
      @letter = Factory(:letter)
      @pdf    = @letter.to_pdf
    end

    it 'responds to #read' do
      @pdf.should be_instance_of(String)
    end
  end

end

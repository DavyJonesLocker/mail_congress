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
      @payment.credit_card.first_name.should == @letter.name_first
      @payment.credit_card.last_name.should  == @letter.name_last
      @payment.street.should                 == @letter.street
      @payment.city.should                   == @letter.city
      @payment.state.should                  == @letter.state
      @payment.zip.should                    == @letter.zip
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

  describe '#build_recipients' do
    before do
      @geoloc = mock('GeoLoc')
      @letter = Letter.new
      @legislator = Legislator.first
      Legislator.stubs(:search).returns([@legislator])
    end

    context 'no pre-existing recipients' do
      before do
        @letter.build_recipients(@geoloc)
      end

      it 'searches for Legislators' do
        Legislator.should have_received(:search).with(@geoloc)
      end

      it 'will return Legislators not marked as selected' do
        @letter.recipients.first.should_not be_selected
      end
    end

    context 'pre-existing recipients' do
      before do
        @letter.recipients = [Recipient.new(:legislator => @legislator)]
        @letter.build_recipients(@geoloc)
      end

      it 'seraches for Legislators' do
        Legislator.should have_received(:search).with(@geoloc)
      end

      it 'marks all pre-existing recipients as selected' do
        @letter.recipients.first.should be_selected
      end

      it 'will ignore duplicates from the Legislator.search results' do
        @letter.recipients.size.should == 1
      end
    end
  end

end

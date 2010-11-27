require 'spec_helper'

describe Letter do
  it { should have_many :recipients }
  it { should have_many :legislators, :through => :recipients }
  it { should belong_to :sender }
  it { should belong_to :campaign }
  it { should accept_nested_attributes_for :recipients }
  it { should accept_nested_attributes_for :sender }
  it { should validate_presence_of :body }

  # context 'associated with a campaign' do
    # subject { Factory.build(:letter, :campaign => Factory.build(:campaign)) }
    # it { should_not validate_presence_of :body }
  # end
  
  describe '#body' do
    context 'associated with a campaign' do
      let(:campaign) { Factory.build(:campaign) }
      subject { Factory.build(:letter, :campaign => campaign) }
      its(:body) { should == campaign.body }
    end

    context 'not associated with a campaign' do
      subject { Letter.new(:body => 'Test Body') }
      its(:body) { should == 'Test Body' }
    end
  end

  describe 'validate there is at least 1 recipient' do
    before do
      @letter_without_recipients = Letter.new
      @letter_with_recipients    = Letter.new(:recipients => [Recipient.new])
      @letter_without_recipients.valid?
      @letter_with_recipients.valid?
    end

    it 'should be invalid when there are no recipients' do
      @letter_without_recipients.errors[:recipients].should include("You must select at least one legislator.")
    end
  end

  describe 'validate the length of text for body' do
    before do
      @letter = Letter.new
      
      @text = <<-TEXT
      This is sample Text

      Paragraph 1

      Paragraph 2
      TEXT
    end

    context 'when it is too long to fit' do
      before do
        @letter.body = @text * 500
        @letter.valid?
      end

      it 'should not be valid for :body' do
        @letter.errors[:body].should include('The letter is too long to fit on one page.')
      end
    end

    context 'when the text is too long for the standard font size' do
      before do
        @letter.body = @text * 10
        @letter.valid?
      end

      it 'should be valid for :body' do
        @letter.errors[:body].should be_empty
      end

      it 'should reduce the font_size from 12' do
        @letter.font_size.should < 12
      end
    end
  end

  describe '#to_pdf' do
    before do
      Prawn::Document.any_instance.stubs(:render)
      @letter   = Factory(:letter, :sender => Factory.build(:sender))
      @letter.stubs(:fit_letter_on_one_page)
      @pdf      = @letter.to_pdf
    end

    it 'renders a pdf' do
      Prawn::Document.any_instance.should have_received(:render)
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

    context 'campaign for only senators' do
      before do
        @campaign = Factory.build(:campaign, :type => 'senator')
        @letter.campaign = @campaign
        Legislator.stubs(:search_senators).returns([@legislator])
        @letter.build_recipients(@geoloc)
      end

      it 'searches only for senators' do
        Legislator.should have_received(:search_senators)
      end
    end
    
    context 'campaign for only representatives' do
      before do
        @campaign = Factory.build(:campaign, :type => 'representative')
        @letter.campaign = @campaign
        Legislator.stubs(:search_representatives).returns([@legislator])
        @letter.build_recipients(@geoloc)
      end

      it 'searches only for representatives' do
        Legislator.should have_received(:search_representatives)
      end
    end
  end

  context 'a sender email address already exists' do
    before do
      @sender = Factory(:sender)
    end

    describe 'instantizing a new letter with sender attributes' do
      it 'searches for an existing sender with the same email address and updates the sender_attributes as well as #sender_id' do
        letter = Letter.new(:sender_attributes => {:email => @sender.email})
        letter.sender_id.should == @sender.id
        letter.sender.id.should == @sender.id
      end
    end
  end

  describe '#to_png' do
    before do
      @letter    = Factory.build(:letter)
      @file_name = @letter.to_png
    end

    it 'writes a PNG' do
      expect {
        file = File.open("#{Rails.root}/public/images/tmp/#{@file_name}")
      }.to_not raise_error
    end
  end

end

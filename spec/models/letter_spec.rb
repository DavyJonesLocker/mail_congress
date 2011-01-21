require 'spec_helper'

describe Letter do
  it { should have_many :recipients }
  it { should have_many :legislators, :through => :recipients }
  it { should belong_to :sender }
  it { should belong_to :campaign }
  it { should accept_nested_attributes_for :recipients }
  # it { should accept_nested_attributes_for :federal_recipients }
  # it { should accept_nested_attributes_for :state_recipients }
  it { should accept_nested_attributes_for :sender }
  it { should validate_presence_of :body }

  # context 'associated with a campaign' do
    # subject { Factory.build(:letter, :campaign => Factory.build(:campaign)) }
    # it { should_not validate_presence_of :body }
  # end
  
  describe '.perform' do
    before do
      @id     = 1
      @method = :test_method
      @letter = mock('Letter')
      @letter.stubs(@method)
      Letter.stubs(:find).returns(@letter)
      Letter.perform(@id, @method)
    end

    it 'finds an instance by the id' do
      Letter.should have_received(:find).with(@id)
    end

    it 'calls the method on the instance' do
      @letter.should have_received(@method)
    end
  end

  describe '#generate_follow_up_id' do
    before do
      @letter = Letter.new(:sender_attributes => Factory.attributes_for(:sender))
    end

    it 'creates a randomized SHA1 string' do
      @letter.follow_up_id.should be_blank
      @letter.generate_follow_up_id!
      @letter.follow_up_id.should_not be_blank
    end
  end

  describe '#delivery_notification' do
    before do
      @mail = mock('mail')
      @mail.stubs(:deliver)
      SenderMailer.stubs(:delivery_notification).returns(@mail)
      @letter = Letter.new
      @letter.delivery_notification
    end

    it 'sends a delivery notfication email' do
      SenderMailer.should have_received(:delivery_notification).with(@letter)
      @mail.should have_received(:deliver)
    end
  end

  describe '#body' do
    context 'associated with a campaign' do
      let(:campaign) { Factory.build(:campaign, :body => 'Line 1') }
      subject { Factory.build(:letter, :body => 'Line 2', :campaign => campaign) }
      its(:body) { should == "Line 1\n\nLine 2" }
    end

    context 'associated with a campaign and has no personal message' do
      let(:campaign) { Factory.build(:campaign, :body => 'Line 1')}
      subject { Factory.build(:letter, :body => '', :campaign => campaign) }
      its(:body) { should == 'Line 1' }
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

    context 'campaign' do
      before do
        @campaign = mock('Campaign')
        @campaign.stubs(:level_and_type).returns({:level => 'federal', :type => 'senate'})
        @letter.stubs(:campaign).returns(@campaign)
        @letter.build_recipients(@geoloc)
      end

      it 'searches only for senators' do
        Legislator.should have_received(:search).with(@geoloc, {:level => 'federal', :type => 'senate'})
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

  describe '#to_redis!' do
    before do
      letter_attributes = Factory.attributes_for(:letter, :payment_type => 'paypal', :sender_attributes => Factory.attributes_for(:sender), :sender => nil)
      @letter = Letter.new(letter_attributes)
      @letter.stubs(:generate_redis_key).returns('redis_key')
      @letter.stubs(:to_json).returns(letter_attributes.to_json)
      @redis = mock('Redis')
      Redis.stubs(:new).returns(@redis)
      @redis.stubs(:setex)
      @result = @letter.to_redis!
    end

    it 'stores the attributes in Redis' do
      @redis.should have_received(:setex).with('redis_key', 3600, @letter.to_json)
    end

    it 'returns the unique key' do
      @result.should == 'redis_key'
    end
  end

  describe '.create_from_redis' do
    before do
      @redis = mock('Redis')
      @redis.stubs(:get).with('redis_key').returns(Factory.attributes_for(:letter).to_json)
      Redis.stubs(:new).returns(@redis)
      @letter = Letter.get_from_redis('redis_key')
    end

    it 'creates a valid letter' do
      @letter.body.should_not be_nil
    end
  end

  describe '#cost' do
    before do
      @letter = Factory.build(:letter, :recipients => [Recipient.new, Recipient.new])
    end

    it 'calculates the cost based upon the number of recipients' do
      @letter.cost.should == 200
    end
  end

  describe 'recipients' do
    before do
      @letter  = Letter.new
      @federal = Recipient.new(:legislator => Legislator.new)
      @state   = Recipient.new(:legislator => Legislator.new)
      @federal.legislator.level = 'federal'
      @state.legislator.  level = 'state'
      @letter.recipients << @federal
      @letter.recipients << @state
    end
    context '#federal_recipients' do
      it 'returns only [@federal]' do
        @letter.federal_recipients.should == [@federal]
      end
    end

    context '#state_recipients' do
      it 'returns only [@state]' do
        @letter.state_recipients.should == [@state]
      end
    end
  end

end

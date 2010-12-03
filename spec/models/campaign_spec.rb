require 'spec_helper'

describe Campaign do
  it { should have_many :letters }
  it { should belong_to :advocacy_group }
  it { should validate_presence_of :title }
  it { should validate_presence_of :summary }
  it { should validate_presence_of :body }

  describe 'Highchart methods' do
    before do
      Timecop.travel DateTime.parse('2010-12-01T00:00:00-05:00').beginning_of_day
      @campaign = Factory(:campaign)
      letter_1 = Factory(:letter, :campaign => @campaign, :created_at => 1.days.from_now, :updated_at => 2.days.from_now, :recipients => [Recipient.new(:legislator => Legislator.first), Recipient.new(:legislator => Legislator.last)], :follow_up_made => true)
      letter_2 = Factory(:letter, :campaign => @campaign, :recipients => [Recipient.new(:legislator => Legislator.first)])
    end

    describe '#activity_days' do
      it 'is an array of all days from the day the campaign was created to the day the last updated letter' do
        @campaign.activity_days.should == ['Dec 01', 'Dec 02', 'Dec 03']
      end
    end

    describe '#letters_sent' do
      it 'is an array show letters sent activity for the entire course of acitivity of the campaign' do
        @campaign.letters_sent.should == [1, 2, 0]
      end
    end

    describe '#follow_ups_made' do
      it 'is an array show letters sent activity for the entire course of acitivity of the campaign' do
        @campaign.follow_ups_made.should == [0, 0, 2]
      end
    end
  end
end

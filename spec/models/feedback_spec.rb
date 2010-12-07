require 'spec_helper'

describe Feedback do
  it { should validate_presence_of :email, :body }

  describe '.new' do
    before do
      @feedback = Feedback.new(:email => 'test@test.com')
    end

    it 'assigns the hash values to the accessors' do
      @feedback.email.should == 'test@test.com'
    end
  end

  describe '.model_name' do
    before do
      @name = Feedback.model_name
    end

    it 'is "Feedback"' do
      @name.should == 'Feedback'
    end

    it 'is an instance of ActiveModel::Name' do
      @name.should be_instance_of(ActiveModel::Name)
    end
  end

  describe '#mail' do
    before do
      @feedback = Feedback.new
      @mailer   = mock('SenderMailer')
      @mailer.stubs(:deliver)
      SenderMailer.stubs(:feedback).returns(@mailer)
      @feedback.mail
    end

    it 'delivers SenderMailer' do
      SenderMailer.should have_received(:feedback).with(@feedback)
      @mailer.should have_received(:deliver)
    end
  end
end

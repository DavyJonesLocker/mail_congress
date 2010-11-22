require "spec_helper"

describe AdvocacyGroupMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe '#confirmation_process' do
    before :all do
      @advocacy_group = Factory.build(:advocacy_group)
      @email          = AdvocacyGroupMailer.confirmation_process(@advocacy_group)
    end

    it 'is delivered to the email of the sender of the letter' do
      @email.should deliver_to(@advocacy_group.email)
    end
  end

  describe '#approval_confirmation' do
    before :all do
      @advocacy_group = Factory.build(:advocacy_group)
      @email          = AdvocacyGroupMailer.approval_confirmation(@advocacy_group)
    end

    it 'is delivered to the email of the sender of the letter' do
      @email.should deliver_to(@advocacy_group.email)
    end
  end
end

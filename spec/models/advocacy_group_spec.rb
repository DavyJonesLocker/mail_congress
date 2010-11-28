require 'spec_helper'

describe AdvocacyGroup do

  it { should have_many :campaigns }

  it { should validate_presence_of :name }
  it { should validate_presence_of :contact_name }
  it { should validate_presence_of :website }
  it { should validate_presence_of :purpose }

  describe 'uniqueness' do
    before { Factory(:advocacy_group) }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :email }
  end

  describe '#approve!' do
    before do
      @advocacy_group = Factory(:advocacy_group, :approved => false)
      @mail = mock('Mail')
      @mail.stubs(:deliver)
      AdvocacyGroupMailer.stubs(:approval_confirmation).returns(@mail)
      @advocacy_group.approve!
    end
    it 'approves the group' do
      @advocacy_group.approved.should be_true
    end

    it 'sends the approval confirmail email' do
      AdvocacyGroupMailer.should have_received(:approval_confirmation).with(@advocacy_group)
      @mail.should have_received(:deliver)
    end
  end
end

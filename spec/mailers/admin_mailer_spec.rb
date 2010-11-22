require "spec_helper"

describe AdminMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe '#confirmation_process' do
    before :all do
      @advocacy_group = Factory.build(:advocacy_group)
      @email          = AdminMailer.new_advocacy_group(@advocacy_group)
    end

    it 'is delivered to the email of the sender of the letter' do
      @email.should deliver_to('brian@mailcongress.org')
    end

    it 'has a subject of "[MailCongress] New Advocacy Group -"' do
      @email.should have_subject "[MailCongress] New Advocacy Group - #{@advocacy_group.name}"
    end

    it 'contains all of the data for the group' do
      %w{name contact_name email web_site phone_number purpose created_at}.each do |attr|
        @email.should have_body_text(/#{@advocacy_group.send(attr)}/)
      end
    end
  end
end

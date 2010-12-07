require "spec_helper"

describe SenderMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe '#print_notification' do
    context '1 recipient' do
      before :all do
        recipients = [Recipient.new(:legislator => Legislator.first)]
        @letter    = Factory.build(:letter, :recipients => recipients, :sender => Factory.build(:sender))
        @email     = SenderMailer.print_notification(@letter)
      end

      it 'is delivered to the email of the sender of the letter' do
        @email.should deliver_to(@letter.sender.email)
      end

      it 'lists the recipient of the letter in the body' do
        @letter.recipients.each do |recipient|
          @email.should have_body_text(recipient.legislator.name)
        end
      end

      it 'contains an estimated time of delivery' do
        @email.should have_body_text(/Your letter should arrive in \d+ business days./)
      end

      it 'has a subject notifying this is a print notification' do
        @email.should have_subject('[MailCongress] Your letter has finished printing and is ready to ship.')
      end
    end
    context 'more than 1 recipient' do
      before :all do
        recipients = [Recipient.new(:legislator => Legislator.first),
                      Recipient.new(:legislator => Legislator.last)]
        @letter    = Factory.build(:letter, :recipients => recipients, :sender => Factory.build(:sender))
        @email     = SenderMailer.print_notification(@letter)
      end

      it 'is delivered to the email of the sender of the letter' do
        @email.should deliver_to(@letter.sender.email)
      end

      it 'lists the recipients of the letter in the body' do
        @letter.recipients.each do |recipient|
          @email.should have_body_text(recipient.legislator.name)
        end
      end

      it 'contains an estimated time of delivery' do
        @email.should have_body_text(/Your letters should arrive in \d+ business days./)
      end

      it 'has a subject notifying this is a print notification' do
        @email.should have_subject('[MailCongress] Your letters have finished printing and are ready to ship.')
      end
    end
  end

  describe '#delivery_notification' do
    context '1 recipient' do
      before :all do
        recipients = [Recipient.new(:legislator => Legislator.first)]
        @letter    = Factory.build(:letter, :recipients => recipients, :sender => Factory.build(:sender))
        @email     = SenderMailer.delivery_notification(@letter)
      end

      it 'is delivered to the email of the sender of the letter' do
        @email.should deliver_to(@letter.sender.email)
      end

      it 'lists the recipient of the letter in the body' do
        @letter.recipients.each do |recipient|
          @email.should have_body_text(recipient.legislator.name)
        end
      end

      it 'has a subject notifying this is a delivery notification' do
        @email.should have_subject('[MailCongress] Your letter has arrived.')
      end
    end

    context 'more than 1 recipient' do
      before :all do
        recipients = [Recipient.new(:legislator => Legislator.first),
                      Recipient.new(:legislator => Legislator.last)]
        @letter    = Factory.build(:letter, :recipients => recipients, :sender => Factory.build(:sender))
        @email     = SenderMailer.delivery_notification(@letter)
      end

      it 'is delivered to the email of the sender of the letter' do
        @email.should deliver_to(@letter.sender.email)
      end

      it 'lists the recipients of the letter in the body' do
        @letter.recipients.each do |recipient|
          @email.should have_body_text(recipient.legislator.name)
        end
      end

      it 'has a subject notifying this is a delivery notification' do
        @email.should have_subject('[MailCongress] Your letters have arrived.')
      end
    end
  end

end

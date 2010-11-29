class SenderMailer < ActionMailer::Base
  default :from => 'notice@mailcongress.org'

  def print_notification(letter)
    @letter = letter
    if @letter.recipients.size == 1
      subject = '[MailCongress] Your letter has finished printing and is ready to ship.'
    else
      subject = '[MailCongress] Your letters have finished printing and are ready to ship.'
    end

    mail(:to => @letter.sender.email, :subject => subject)
  end

  def delivery_notification(letter)
    @letter = letter
    if @letter.recipients.size == 1
      subject = '[MailCongress] Your letter has arrived.'
    else
      subject = '[MailCongress] Your letters have arrived.'
    end

    mail(:to => @letter.sender.email, :subject => subject)
  end
end

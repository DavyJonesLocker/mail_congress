class AdvocacyGroupMailer < ActionMailer::Base
  default :from => 'notice@mailcongress.org'

  def confirmation_process(advocacy_group)
    @advocacy_group = advocacy_group
    mail(
      :to => @advocacy_group.email,
      :subject => '[MailCongress] We have received your application.'
    )
  end

  def approval_confirmation(advocacy_group)
    @advocacy_group = advocacy_group
    mail(
      :to => @advocacy_group.email,
      :subject => '[MailCongress] Your group has been approved!'
    )
  end
end

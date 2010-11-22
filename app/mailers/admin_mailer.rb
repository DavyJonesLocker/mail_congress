class AdminMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def new_advocacy_group(advocacy_group)
    @advocacy_group = advocacy_group
    mail(
      :to => 'brian@mailcongress.org',
      :subject => "[MailCongress] New Advocacy Group - #{@advocacy_group.name}"
    )
  end
end

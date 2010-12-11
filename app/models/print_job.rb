class PrintJob
  @queue = :high

  def self.enqueue(letter)
    Resque.enqueue(PrintJob, letter.id)
  end

  def self.perform(letter_id)
    letter = Letter.find(letter_id)
    
    print_job = Cups::PrintJob::Transient.new(letter.to_pdf)
    print_job.print

    while print_job.state == :processing
      sleep(0.5)
    end

    if print_job.state == :completed
      letter.update_attributes(:printed => true) #, :body => '')
      SenderMailer.print_notification(letter).deliver
      Resque.enqueue_at(10.business_days.from_now, Letter, letter.id, :delivery_notification)
    else
      self.enqueue(letter)
    end
  end
  
end

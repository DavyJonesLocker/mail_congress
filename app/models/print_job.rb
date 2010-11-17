class PrintJob
  @queue = 'high'

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
      letter.update_attribute(:printed, true)
      SenderMailer.print_notification(letter).deliver
    else
      self.enqueue(letter)
    end
  end
  
end

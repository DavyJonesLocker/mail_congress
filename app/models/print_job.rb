class PrintJob
  @queue = "print_jobs-#{Rails.env}"

  def self.enqueue(letter)
    Resque.enqueue(PrintJob, letter.id)
  end

  def self.perform(letter_id)
    letter = Letter.find(letter_id)
    
    print_job = Cups::PrintJob::Transient.new(letter.to_pdf)
    print_job.print

    loop do
      sleep(0.5)
      break if print_job.state == :completed
    end
  end
  
end

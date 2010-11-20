Given /^print jobs have been stubbed out$/ do
  print_job = mock('TransientPrintJob')
  print_job.stubs(:print).returns(true)
  print_job.stubs(:state).returns(:completed)
  Cups::PrintJob::Transient.stubs(:new).returns(print_job)
end


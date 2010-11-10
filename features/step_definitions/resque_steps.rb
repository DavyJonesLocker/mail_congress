Then /the letter has print queued/ do
  letter = Letter.last
  PrintJob.should have_queued(letter.id)
end

Given /^a new enqueued letter with (\d+) recipient$/ do |count|
  recipients = Legislator.limit(count).inject([]) do |collection, legislator|
    collection << Recipient.new(:legislator => legislator)
  end

  letter = Factory(:letter, :recipients => recipients)
  Resque::Job.create('high', PrintJob, letter.id)
end

When /^the job is processed$/ do
  worker = Resque::Worker.new('high')
  job    = worker.reserve
  worker.perform(job)
  worker.failed.should == 0
end

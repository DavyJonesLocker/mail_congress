Given /^Resque is clear$/ do
  Resque.redis.flushdb
end

Then /the letter has print queued/ do
  letter = Letter.last
  worker = Resque::Worker.new('high')
  job    = worker.reserve
  job.inspect.should match(/PrintJob/)
  job.inspect.should match(/#{letter.id}/)
end

Given /^a new enqueued letter with (\d+) recipient$/ do |count|
  recipients = Legislator.limit(count).inject([]) do |collection, legislator|
    collection << Recipient.new(:legislator => legislator)
  end

  letter = Factory(:letter, :recipients => recipients)
  Resque::Job.create('high', PrintJob, letter.id)
end

When /^the "([^"]*)" job is processed$/ do |queue|
  worker = Resque::Worker.new(queue)
  job    = worker.reserve
  worker.perform(job)
  worker.failed.should == 0
end

Then /^the scheduled jobs have been processed$/ do
  Resque::Scheduler.handle_delayed_items
  When %{the "letter" job is processed}
end


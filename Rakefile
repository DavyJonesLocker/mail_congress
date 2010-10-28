# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'resque/tasks'

MailCongress::Application.load_tasks

namespace :spork do
  desc 'Launch RSpec and Cucumber Spork Servers'
  task :all do
    rspec
    cucumber
  end

  desc 'Launch RSpec Spork Server'
  task :rspec do
    puts 'Launching RSpec Spork Server... '
    system('bundle exec spork rspec -p 8990 &')
    print 'Done.'
  end

  desc 'Launch Cucumber Spork Server'
  task :cucumber do
    puts 'Launching Cucumber Spork Server... '
    system('bundle exec spork cuc -p 8991 &')
    print 'Done.'
  end
end

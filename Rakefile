# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'ruby-debug'
require 'daemons'

task "resque:setup" => :environment

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

  namespace :cucumber do
    desc 'Launch Cucumber Spork Server'
    task :start do
      path = File.dirname(File.expand_path(__FILE__))
      puts 'Launching Cucumber Spork Server... '
      Daemons.run_proc('cucumber', :ARGV => ['start']) do
        Spork::Runner(['cuc', '-p', '8991'], STDOUT, STDERR)
      end
    end
    
    task :stop do
      puts 'Stopping Cucumber Spork Server...'
      Daemons.run_proc('cucumber', :ARGV => ['stop'])
    end
  end
end

namespace :db do
  desc 'Shortcut to drop, create and migrate'
  task :recreate do
    %w{drop create migrate}.each do |type|
      Rake::Task["db:#{type}"].invoke
    end
  end
end

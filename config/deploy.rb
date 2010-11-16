require 'bundler/capistrano'

set :application, 'mail_congress'
set :deploy_to, "/home/deploy/#{application}"

set :branch, "master"

role :web, "mailcongress.org"
role :app, "mailcongress.org"
role :db,  "mailcongress.org", :primary => true

set :user, "deploy"
set :use_sudo, false

default_run_options[:pty] = true
set :scm, :git
set :repository, 'git@github.com:dirtywater/mail_congress.git'
set :deploy_via, :remote_cache

# set :stage, :production
set :keep_releases, 5

before 'deploy:restart', 'deploy:symlink_tmp'
after  'deploy:update', 'deploy:cleanup'
after  'deploy:restart', 'resque:restart'

namespace :deploy do
  desc "Start the unicorn server"
  task :start do ; end
  desc "Stop the unicorn server"
  task :stop do ; end
  desc "Restart the unicorn server"
  task :restart, :roles => :app, :except => { :no_release => true } do  
    run "god stop #{application}"
    run "god load #{current_path}/config/deploy/mail_congress.god"
    run "god start #{application}"
  end
  
  task :symlink_tmp do
    run "ln -sf #{current_path}/public/images/tmp /tmp/images" 
  end
end

namespace :resque do
  desc 'Start Resque'
  task :start do
    run "god load #{current_path}/config/deploy/resque.god"
    run 'god start resque'
  end

  desc 'Stop Resque'
  task :stop do
    run "cd #{current_path} && rake resque:stop"
  end

  desc 'Restart Resque'
  task :restart do
    stop
  end
end


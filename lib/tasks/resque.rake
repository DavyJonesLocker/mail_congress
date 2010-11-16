namespace :resque do
  desc 'Stop all Resque workers'
  task :stop => :environment do
    pids = Array.new
    
    Resque.workers.each do |worker|
      pids.concat(worker.worker_pids)
    end
    
    system("kill -QUIT #{pids.join(' ')} && rm /home/deploy/.god/pids/resque-*")
  end
end

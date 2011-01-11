source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'pg', '0.9.0'

gem 'simple_form'
gem 'geokit'
gem 'escape_utils'
gem 'sass', '3.1.0.alpha.19'
gem 'haml', '3.1.0.alpha.22'
gem 'compass'
gem 'activemerchant'
gem 'resque'
gem 'resque-scheduler', :require => 'resque_scheduler'
gem 'SystemTimer'
gem 'cups', :git => 'git://github.com/bcardarella/cups.git', :branch => 'options', :require => 'cups/print_job/transient'
gem 'prawn', :git => 'git://github.com/bcardarella/prawn.git', :submodules => true
gem 'rmagick', :require => 'RMagick'
gem 'hoptoad_notifier'
gem 'orm_adapter', :git => 'git://github.com/ianwhite/orm_adapter.git'
gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
gem 'business_time', :git => 'git://github.com/dirtywater/business_time.git'
gem 'daemons'
gem 'fastercsv'

group :development do
  gem 'mongrel', '1.2.0.pre2'
end

group :production do
  gem 'unicorn'
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'ruby-debug'
end

group :test, :cucumber do
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem 'capybara'
  # gem 'capybara-envjs', :git => 'http://github.com/smparkes/capybara-envjs.git'
  # gem 'capybara-envjs-fixes'
  gem 'database_cleaner'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'bourne'
  gem 'spork', '0.9.0.rc2'
  gem 'launchy'
  gem 'remarkable_activerecord', '4.0.0.alpha4'
  gem 'email_spec', :git => 'https://github.com/bmabey/email-spec.git'
  gem 'timecop'
  gem 'chronic', :git => 'git://github.com/mojombo/chronic.git'
  gem 'fakeweb'
end

group :test do
  gem 'resque_spec'
end

source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2', "~> 0.3.11"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', "~> 0.11.4"

  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '~> 0.12.1'
  gem 'compass-rails', "~> 1.0.3"
  gem 'yui-compressor', "~> 0.9.6"
end

group :development do
  gem 'progress_bar'
  # To use debugger
  gem 'reek'
end

group :test do
  gem 'sunspot_solr', "~> 1.3.3"
  #Testing coverage
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'ruby-prof' #For Benchmarking
  gem 'coveralls', "~> 0.6.2", :require => false
  gem "vcr", "~> 2.4.0"
  gem "webmock", "~> 1.11.0"
end

gem 'json', "~> 1.7.7"

gem 'debugger', :groups => [:development, :test]

#gem 'nyulibraries_assets', :path => "/apps/nyulibraries_assets"
gem 'nyulibraries_assets', :git => 'git://github.com/NYULibraries/nyulibraries_assets.git'
gem 'jquery-rails', "~> 2.2.0"

# Deploy with Capistrano
gem 'rvm-capistrano', "~> 1.2.7"

# For config settings
gem "rails_config", "~> 0.3.2"

# Authenticate gem
gem 'authpds-nyu', "~> 0.2.9"

# Aleph config gem
gem "exlibris-nyu", :git => "git://github.com/NYULibraries/exlibris-nyu.git", :tag => 'v1.0.0'

# Pagination
gem "kaminari", "~> 0.13"

# New Relic
gem 'newrelic_rpm', "~> 3.5.3"

# Sunspot
gem 'sunspot_rails', "~> 1.3.3"

# Background jobs
gem 'delayed_job_active_record', "~> 0.4.3"
gem 'daemons', "~> 1.1.9"

gem 'mustache-rails', "~> 0.2.3", :require => 'mustache/railtie'

# memcached
gem 'dalli', "~> 2.6.2"

gem "comma", "~> 3.0"

source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'mysql2', '~> 0.3.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0'

  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '~> 0.12.1'
  gem 'compass-rails', '~> 1.0.3'
  gem 'yui-compressor', '~> 0.b12.0'
end

group :development do
  gem 'progress_bar'
  # To use debugger
  #gem 'reek'
end

group :test do
  gem 'sunspot_solr', '~> 1.3.3'
  #Testing coverage
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'ruby-prof' #For Benchmarking
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'vcr', '~> 2.6.0'
  gem 'webmock', '~> 1.14.0'
end

gem 'json', '~> 1.8.0'

gem 'debugger', :groups => [:development]

gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.1.0'

# For config settings
gem 'rails_config', '~> 0.3.3'

gem 'exlibris-nyu', :git => 'git://github.com/NYULibraries/exlibris-nyu.git', :tag => 'v1.1.3'
gem 'authpds-nyu', :git => 'git://github.com/NYULibraries/authpds-nyu.git', :tag => 'v1.1.3'
gem 'nyulibraries-assets', :git => 'git://github.com/NYULibraries/nyulibraries-assets.git', :tag => 'v2.0.1'
gem 'nyulibraries_deploy', :git => 'git://github.com/NYULibraries/nyulibraries_deploy.git', :tag => 'v3.2.1'

# Pagination
gem 'kaminari', '~> 0.15.0'

# New Relic
gem 'newrelic_rpm', '~> 3.6.0'

# Sunspot
gem 'sunspot_rails', '~> 2.1.0'

# Background jobs
gem 'delayed_job_active_record', '~> 0.4.3'
gem 'daemons', '~> 1.1.9'

gem 'mustache', '0.99.4'
gem 'mustache-rails', '~> 0.2.3', :require => 'mustache/railtie'

# memcached
gem 'dalli', '~> 2.6.2'

gem 'comma', '~> 3.2.0'

# Peek and plugins
gem 'peek'
gem 'peek-git'
gem 'peek-mysql2'
gem 'peek-dalli'
gem 'peek-performance_bar'
gem 'peek-rblineprof'
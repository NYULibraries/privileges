source 'https://rubygems.org'

gem 'rails', '~>3.2.18'

gem 'mysql2', '~> 0.3.16'
gem 'json', '~> 1.8.0'
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 4.2.1'
gem 'exlibris-nyu', :git => 'git://github.com/NYULibraries/exlibris-nyu.git', :tag => 'v1.1.4'
gem 'authpds-nyu', :git => 'git://github.com/NYULibraries/authpds-nyu.git', :tag => 'v1.1.3'
gem 'nyulibraries-assets', :git => 'git://github.com/NYULibraries/nyulibraries-assets.git', :tag => 'v2.0.1'
gem 'figs', '~> 2.0.2'
gem 'formaggio', github: 'NYULibraries/formaggio', :tag => 'v1.0.1'
gem 'kaminari', '~> 0.15.0'
gem 'newrelic_rpm', '~> 3.8.0'
gem 'sunspot_rails', '~> 2.1.1'
gem 'delayed_job_active_record', '~> 0.4.3'
gem 'daemons', '~> 1.1.9'
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', require: 'mustache/railtie'
gem 'dalli', '~> 2.7.2'
gem 'comma', '~> 3.2.1'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'therubyracer', '~> 0.12.0'

  gem 'uglifier', '~> 2.4.0'
  gem 'compass', '~> 0.12.1'
  gem 'compass-rails', '~> 1.1.3'
  gem 'yui-compressor', '~> 0.b12.0'
end

group :test do
  gem 'sunspot_solr', '~> 2.1.0'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'vcr', '~> 2.8.0'
  gem 'webmock', '~> 1.16.1'
end

group :development do
  gem 'progress_bar'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails', '~> 4.4.0'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'pry', '~> 0.10.1'
end

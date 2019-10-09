source 'https://rubygems.org'

gem 'rails', '= 5.2.2.1'

# Use MySQL for the database
gem 'mysql2', '0.4.10'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'
gem 'sprockets', '~> 3.7.2'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.3.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 6.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.0.0'

# Use acts as indexed to search models
gem 'acts_as_indexed', '~> 0.8.3'

# Use Devise & OAuth2
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries', tag: 'v2.1.1'
gem 'devise', '~> 4.6'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.1.2'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.2.5'
# Bootstrap SASS lock to lower version for server compatibility
gem 'bootstrap-sass', '3.3.7'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.3'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.1.1'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.7.2'

# Use Kaminari for pagination
gem 'kaminari', '~> 1.1.1'

# For memcached
gem 'dalli', '~> 2.7.0'

# Create CSVs from models
gem 'comma', '~> 4.2.0'

# Use Sunspot for search
gem 'rsolr', '~> 1'
gem 'sunspot_rails', '~> 2.3.0'

gem 'record_tag_helper', '~> 1.0.0'

gem 'sentry-raven', '~> 2'

# Locks in Exlibris Primo dependency for Rails 5 compatibility
gem 'exlibris-primo', github: 'nyulibraries/exlibris-primo', tag: 'v2.2.0'
gem 'exlibris-nyu', github: 'nyulibraries/exlibris-nyu', tag: 'v2.4.1'

group :development do
  gem 'better_errors', '~> 2.3.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'progress_bar', '~> 1.1.0'
  gem 'listen', '~> 3.1.5'
end

group :development, :test do
  # Use Puma as the app server for testing and local development
  gem 'puma', '~> 3.12'
  # Allows dalli cache store compaitibility with multithreaded servers
  gem 'connection_pool'
  # Development solr instance from Sunspot
  gem 'sunspot_solr', '~> 2.3.0'
  # Debugging in development, tests
  gem "byebug", "~> 11.0"
end

group :test do
  gem 'rspec-rails', '~> 3.6.0'
  gem 'rspec-its'
  # Phantomjs for headless browser testings
  gem 'capybara-screenshot'
  # Use factory bot for creating models
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'cucumber-rails', '~> 1.6.0', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.8.0', require: false
  gem 'selenium-webdriver', '~> 3.4.0'
  gem 'database_cleaner', '~> 1.6.0'
  gem 'rails-controller-testing'
end

group :production do
  gem 'unicorn', '~> 5.3.0'
end

group :no_docker do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0'
end

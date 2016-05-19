source 'https://rubygems.org'

gem 'rails', '~> 4.1.14.2'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.16'

# Use SCSS for stylesheets
gem 'sass-rails',   '5.0.0.beta1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 5.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

# Use acts as indexed to search models
gem 'acts_as_indexed', '~> 0.8.3'

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'NYULibraries/mustache-rails', require: 'mustache/railtie', tag: 'v0.2.3'

# Use Exlibris::Nyu for NYU Exlibris customizations, etc.
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.1.3'

# Use Devise & OAuth2
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries', tag: 'v2.0.0'
gem 'devise', '~> 3.5.4'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.4.3'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.5.2'

# Use Kaminari for pagination
gem 'kaminari', '~> 0.16.0'

# For memcached
gem 'dalli', '~> 2.7.0'

# Create CSVs from models
gem 'comma', '~> 3.2.0'

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 3.9.0'

# Use Sunspot for search
gem 'sunspot_rails', '~> 2.2.0'

# Development solr instance from Sunspot
gem 'sunspot_solr', '~> 2.2.0', group: [:test, :development]

gem 'foreman', '~> 0.78.0'

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'progress_bar', '~> 1.0.3'
end

group :development, :test, :cucumber do
  gem 'rspec-rails', '~> 3.1.0'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.5.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.5.0'
  # Use pry-debugger as the REPL and for debugging
  gem 'pry', '~> 0.10.1'
end

group :test, :cucumber do
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.19.0'
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.3.0'
end

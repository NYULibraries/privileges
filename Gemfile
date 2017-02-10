source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

# Use MySQL for the database
gem 'mysql2', '~> 0.4.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.2.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 6.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.0.0'

# Use acts as indexed to search models
gem 'acts_as_indexed', '~> 0.8.3'

# Use Exlibris::Nyu for NYU Exlibris customizations, etc.
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.1.3'

# Use Devise & OAuth2
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries', tag: 'v2.1.1'
gem 'devise', '~> 4.2.0'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.0.1'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.1'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.0.1'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.0.1'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.5.2'

# Use Kaminari for pagination
gem 'kaminari', '~> 1.0.0'

# For memcached
gem 'dalli', '~> 2.7.0'

# Create CSVs from models
gem 'comma', '~> 4.0.0'

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 3.18'

# Use Sunspot for search
gem 'sunspot_rails', '~> 2.2.0'

gem 'foreman', '~> 0.83'

group :development do
  gem 'better_errors', '~> 2.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'progress_bar', '~> 1.1.0'
end

group :development, :test, :cucumber do
  # Use pry-debugger as the REPL and for debugging
  gem 'pry', '~> 0.10.1'
  # Development solr instance from Sunspot
  gem 'sunspot_solr', '~> 2.2.0'
end

group :test, :cucumber do
  gem 'rspec-rails', '~> 3.5.0'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.13.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.8.0', require: false
  gem 'vcr', '~> 3.0.0'
  gem 'webmock', '~> 2.3.0'
  gem 'selenium-webdriver', '~> 3.0.5'
  gem 'database_cleaner', '~> 1.5.0'
end

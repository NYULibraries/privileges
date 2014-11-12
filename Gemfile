source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.16'

# Use SCSS for stylesheets
gem 'sass-rails',   '>= 5.0.0.beta1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 5.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

# Use acts as indexed to search models
gem 'acts_as_indexed', '~> 0.8.3'

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', require: 'mustache/railtie', tag: 'v0.2.3'

# Use Exlibris::Nyu for NYU Exlibris customizations, etc.
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.1.3'

# Use AuthPDS for authentication and authorization
gem 'authpds-nyu', github: 'NYULibraries/authpds-nyu', :tag => 'v2.0.1'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.0.4'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.0.1'

# Use Figs for setting the configuration in the Environment
gem 'figs', '~> 2.0.2'

# Use Kaminari for pagination
gem 'kaminari', '~> 0.16.0'

# For memcached
gem 'dalli', '~> 2.7.0'

# Create CSVs from models
gem 'comma', '~> 3.2.0'

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 3.9.0'

# Use Sunspot for search
gem 'sunspot_rails', '~> 2.1.1'

group :test do
  gem 'sunspot_solr', '~> 2.1.0'
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'vcr', '~> 2.9.0'
  gem 'webmock', '~> 1.20.0'
end

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'progress_bar', '~> 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'pry', '~> 0.10.1'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
# Wear merged coveralls for rails
require 'coveralls'
Coveralls.wear_merged!('rails')

require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'
require 'database_cleaner'
require 'byebug'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods

  # Include the Devise test helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.before(:suite) do
    # Startout by trucating all the tables
    DatabaseCleaner.clean_with :truncation
    # Then use transactions to roll back other changes
    DatabaseCleaner.strategy = :transaction

    # Run factory bot lint before the suite
    begin
      DatabaseCleaner.start
      # FactoryBot.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
    Sunspot.remove_all!(PatronStatus) if PatronStatus.any?
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

require 'coveralls'
Coveralls.wear_merged!('rails')

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Remove when removing support for Rails 4
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActiveSupport::TestCase
  fixtures :all
end

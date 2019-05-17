require 'coveralls'
Coveralls.wear_merged!('rails')

require 'byebug'

# Require support classes in spec/support and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each do |helper|
  require helper
end

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |helper|
  require helper
  # Only include _helper.rb methods
  if /_helper.rb/ === helper
    helper_name = "PrivilegesFeatures::#{helper.camelize.demodulize.split('.').first}"
    Cucumber::Rails::World.send(:include, helper_name.constantize)
  end
end

# Configure Capybara
require 'capybara-screenshot/cucumber' if ENV['SCREENSHOT_FAILURES']
Capybara.save_path = "/screenshots"

Capybara.default_max_wait_time = 30

def configure_selenium
  Capybara.register_driver :selenium do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w(no-sandbox headless disable-gpu window-size=1280,1024)
      }
    )

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end
end

configure_selenium
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
Capybara.current_driver = :selenium

Capybara.server = :puma, { Silent: true }
Capybara.app_host = 'http://localhost:3000'
Capybara.server_port = 3000

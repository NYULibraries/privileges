require_relative 'boot'

require 'rails/all'

if Rails.env.staging? || Rails.env.production?
  require 'figs'
  # Don't run this initializer on travis.
  Figs.load(stage: Rails.env)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PrivilegesGuide
  LOCAL_CREATION_PREFIX = 'nyu_ag_noaleph_'

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Rails 5 options:
    config.eager_load_paths << Rails.root.join('lib')

    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true

    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.0
  end
end
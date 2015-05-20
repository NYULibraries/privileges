require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'figs'
# Don't run this initializer on travis.
Figs.load(stage: Rails.env) unless ENV['TRAVIS']

module PrivilegesGuide
  EXAMPLE_ORIGIN = 'example.com'
  LOCAL_CREATION_PREFIX = 'nyu_ag_noaleph_'

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    whitelisted_origins = Rails.env.test? ?
      Eshelf::EXAMPLE_ORIGIN : (["http://ws-balter.bobst.nyu.edu:3000"] || [])

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins *whitelisted_origins
        resource '/sso_logout', headers: :any, methods: [:delete], expose: 'X-CSRF-Token'
      end
    end

    # Autoload the lib path
    config.autoload_paths += %W(#{config.root}/lib)
  end
end

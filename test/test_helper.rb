if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  fixtures :all
end

# VCR is used to 'record' HTTP interactions with
# third party services used in tests, and play em
# back. Useful for efficiency, also useful for
# testing code against API's that not everyone
# has access to -- the responses can be cached
# and re-used.
require 'vcr'
require 'webmock'

# To allow us to do real HTTP requests in a VCR.turned_off, we
# have to tell webmock to let us.
WebMock.allow_net_connect!

VCR.configure do |c|
  c.default_cassette_options = { :record => :once, :allow_playback_repeats => true }
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

unless ENV['CI']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start
end

require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  PatronStatus.reindex
  PatronStatusPermission.reindex
  Sublibrary.reindex
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
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock 
  c.default_cassette_options = {
    :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]
  }  
  # c.debug_logger = $stderr
  #Rc.filter_sensitive_data("aleph.library.edu") { @@aleph_url }
  #Rc.filter_sensitive_data("BOR_ID") { @@aleph_bor_id }
  #Rc.filter_sensitive_data("VERIFICATION") { @@aleph_verification }
  #Rc.filter_sensitive_data("primo.library.edu") { @@primo_url }
  #Rc.filter_sensitive_data("solr.library.edu") { @@solr_url }
end
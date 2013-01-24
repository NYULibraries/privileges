# Be sure to restart your server when you modify this file.

PrivilegesGuide::Application.config.session_store :cookie_store, key: '_privileges_guide_session', :domain => :all

#PrivilegesGuide::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 10.seconds

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# PrivilegesGuide::Application.config.session_store :active_record_store

# Manually include all recipes we're using
require 'formaggio/capistrano/multistage'
require 'formaggio/capistrano/default_attributes'
require 'formaggio/capistrano/figs'
require 'formaggio/capistrano/config'
require 'formaggio/capistrano/assets'
require 'formaggio/capistrano/bundler'
require 'formaggio/capistrano/rvm'
require 'formaggio/capistrano/server/passenger'
require 'formaggio/capistrano/cache'
require 'formaggio/capistrano/cleanup'
require 'formaggio/capistrano/environment'

set :app_title, "privileges"
set :rvm_ruby_string, "ruby-2.6.2"
set :assets_gem, ["nyulibraries_stylesheets.git", "nyulibraries_javascripts.git"]

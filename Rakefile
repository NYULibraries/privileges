#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

PrivilegesGuide::Application.load_tasks

# We need to add the coveralls task in the Rakefile
# because we want to make sure we append it to the very
# end of the default task
if Rails.env.test?
  # Add the coveralls task as the default with the appropriate prereqs
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :test, 'coveralls:push']
end

#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

PrivilegesGuide::Application.load_tasks

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Privileges Guide'
  rdoc.options << '--line-numbers'
  rdoc.options << '--markup markdown'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('app/**/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test

# We need to add the coveralls task in the Rakefile
# because we want to make sure we append it to the very
# end of the default task
if Rails.env.test?
  # Add the coveralls task as the default with the appropriate prereqs
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task default: 'coveralls:push'
end

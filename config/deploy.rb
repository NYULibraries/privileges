# Default require
require 'formaggio/capistrano'
set :app_title, "privileges"
set :rvm_ruby_string, "ruby-2.1.3"

namespace :delayed_jobs do
  desc "Startup delayed jobs script"
  task :restart do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} #{current_path}/bin/delayed_job restart"
  end
end

after "deploy", "delayed_jobs:restart"

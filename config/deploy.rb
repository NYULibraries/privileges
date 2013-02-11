# Load bundler-capistrano gem
require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

# Environments
set :stages, ["staging", "production"]
set :default_stage, "staging"
# Multistage
require 'capistrano/ext/multistage'

set :ssh_options, {:forward_agent => true}
set :app_title, "privileges_guide"
set :application, "#{app_title}_repos"

# RVM  vars
set :rvm_ruby_string, "1.9.3-p125"

# Bundle vars

# Git vars
set :repository, "git@github.com:NYULibraries/privileges_guide.git" 
set :scm, :git
set :deploy_via, :remote_cache
set(:branch, 'master') unless exists?(:branch)
set :git_enable_submodules, 1

set :keep_releases, 5
set :use_sudo, false

# Rails specific vars
set :normalize_asset_timestamps, false

# Deploy tasks
namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job start"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :stop, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job stop"
  end
  task :passenger_symlink do
    run "rm -rf #{app_path}#{app_title} && ln -s #{current_path}/public #{app_path}#{app_title}"
  end
  task :restart_delayed_job do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
  end
end

namespace :cache do
  desc "Clear rails cache"
  task :tmp_clear, :roles => :app do
    run "cd #{current_release} && bundle exec rake tmp:clear RAILS_ENV=#{rails_env}"
  end
  desc "Clear memcache after deployment"
  task :clear, :roles => :app do
    run "cd #{current_release} && bundle exec rake cache:clear RAILS_ENV=#{rails_env}"
  end
end

desc "Cleanup git project"
task :clean_git, :roles => :app do
  # Clean up non tracked git files that aren't explicitly ignoredgit 
  system "git clean -d -f"
end

desc "Generate rdocs and push rdocs and coverage to gh-pages"
task :ghpages, :roles => :app do
  #system "bundle exec rake rdoc RAILS_ENV=#{rails_env} && bundle exec rake ghpages RAILS_ENV=#{rails_env}"
end

before "deploy", "rvm:install_ruby", "deploy:migrations"
before "ghpages", "clean_git"
after "deploy", "ghpages", "deploy:cleanup", "deploy:passenger_symlink", "cache:clear", "cache:tmp_clear"
after "deploy:restart", "deploy:restart_delayed_job"
after "deploy:update", "newrelic:notice_deployment"

set :rails_env, "qa"
set(:branch, ENV["GIT_BRANCH"].gsub(/remotes\//,"").gsub(/origin\//,""))
set :app_title, "privileges_qa"
set :repository, "git@github.com:NYULibraries/privileges.git"

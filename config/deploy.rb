set :user, 'vizvamitra'
set :domain, 'Raumarepola'
set :application, "todolist"

# RVM
set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.0.0-p247'
require 'rvm/capistrano'

# file paths
set :repository, "#{user}@#{domain}:git/#{application}.git"
set :deploy_to, "/home/#{user}/deploy/#{application}"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, domain     # This may be the same as your `Web` server
role :db,  domain     # This is where Rails migrations will run
role :db,  domain, primary: true

# you might need to set this if you aren't seeing password prompts
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :normalize_asset_timestamps, false
set :rails_env, :production

before 'deploy:assets:precompile', 'deploy:symlink_config_files'

namespace :deploy do
  desc "cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end

  desc "reload the database with seed data"
  task :seed do
    deploy.migrations
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
  
  desc "simlink config files to their paths"
  task :symlink_config_files do
    symlinks = { "#{shared_path}/config/database.yml" =>
        "#{release_path}/config/database.yml" }
    run symlinks.map { |from, to| "ln -nfs #{from} #{to}" }.join(" && ")
  end
end
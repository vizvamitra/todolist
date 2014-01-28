set :user, 'vizvamitra'
set :domain, 'horrible'
set :application, "todolist"

# adjust if you are using RVM, remove if you are not
set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.1.0'
require 'rvm/capistrano'

# file paths
set :repository,  "#{user}@Raumarepola:git/#{application}.git" 
#set :deploy_to, "/home/#{user}/deploy/#{application}" 
set :deploy_to, "/home/#{user}/www/#{application}"

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
server domain, :app, :web, primary: true
#role :app, domain
#role :web, domain
#role :db, domain, :primary => true

# you might need to set this if you aren't seeing password prompts
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications.  Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
# default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin'
# default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'design'
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
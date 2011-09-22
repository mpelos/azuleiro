# Bundler Integration
require "bundler/capistrano"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# Application Settings
set :application,   "azul_checker"
set :user,          "deployer"
set :deploy_to,     "/home/#{user}/rails-applications/#{application}"
set :rails_env,     "production"
set :use_sudo,      false
set :keep_releases, 3

# Git Settings
set :scm,           :git
set :branch,        "master"
set :repository,    "git@github.com:mpelos/azul_checker.git"
set :deploy_via,    :remote_cache

# Uses local instead of remote server keys, good for github ssh key deploy.
ssh_options[:forward_agent] = true

# Server Roles
role :web, "173.255.200.12"
role :app, "173.255.200.12"
role :db,  "173.255.200.12", :primary => true

# Passenger Deploy Reconfigure
namespace :deploy do
  desc "Restart passenger process"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} does nothing for passenger"
    task t, :roles => :app do ; end
  end
end

before "deploy:setup", "db:configure", "credentials:configure"
after  "deploy:update_code", "db:symlink", "credentials:symlink"
after  "deploy:symlink", "deploy:cleanup"

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_username do
      "rails"
    end

    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end

    db_config = <<-EOF
      base: &base
        adapter: mysql2
        encoding: utf8
        reconnect: false
        pool: 5
        username: #{database_username}
        password: #{database_password}

      development:
        database: #{application}_development
        <<: *base

      test:
        database: #{application}_test
        <<: *base

      production:
        database: #{application}_production
        <<: *base
        EOF

        run "mkdir -p #{shared_path}/config"
        put db_config, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end

namespace :credentials do
  desc "Create credentials yaml in shared path"
  task :configure do
    set :admin_username do
      Capistrano::CLI.ui.ask "Enter the admin user: "
    end

    set :admin_password do
      Capistrano::CLI.password_prompt "Enter the admin password: "
    end

    set :email_domain do
      Capistrano::CLI.ui.ask "Enter the e-mail domain: "
    end

    set :email_username do
      Capistrano::CLI.ui.ask "Enter the e-mail user: "
    end

    set :email_password do
      Capistrano::CLI.password_prompt "Enter the e-mail password: "
    end

    credentials = <<-EOF
      email:
        domain: "#{email_domain}"
        user: "#{email_username}"
        password: "#{email_password}"
    EOF

    run "mkdir -p #{shared_path}/config"
    put credentials, "#{shared_path}/config/credentials.yml"
  end

  desc "Make symlink for admin and e-mail credentials yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/credentials.yml #{latest_release}/config/credentials.yml"
  end
end

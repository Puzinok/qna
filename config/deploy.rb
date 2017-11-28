# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "qna"
set :repo_url, "git@github.com:Puzinok/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

set :default_shell, '/bin/bash -l'

namespace :deploy do
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :custom do
  desc 'Regenerate Sphinx'
  task :reconf_sphinx do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "ts:regenerate"
        end
      end
    end
  end
end
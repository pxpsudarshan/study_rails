# config valid only for current version of Capistrano
lock '3.20.1'

set :repo_url, 'git@gitlab.kanrin.biz:kanrin/study_rails.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/environments/development.rb', 'Passengerfile.json', 'config/environments/production.rb', 'config/database.yml', 'config/master.key', 'config/models/niho_backup.rb')

# Default value for linked_dirs is []
append :linked_dirs, 'tmp/pdf_files', "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor", "storage"

#set :default_env, { "RAILS_RELATIVE_URL_ROOT" => "/reserve" }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
# set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
set :whenever_roles, [:app, :app_dev]
set :migration_role, [:app, :app_dev]
set :assets_roles, [:app, :app_dev]
set :keep_assets, 2
set :bundle_without, %w{test}

namespace :sidekiq do
  desc 'Перевод Sidekiq в режим тишины (остановка приема новых задач)'
  task :quiet do
    on roles([:app, :app_dev]) do
      # Сигнал TSTP заставляет Sidekiq перестать брать новые задачи из очередей
      execute :sudo, :systemctl, :kill, '--signal=TSTP', :sidekiq, raise_on_non_zero_exit: false
    end
  end

  desc 'Перезапуск Sidekiq на новой версии кода'
  task :restart do
    on roles([:app, :app_dev]) do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end
end

# Автоматические хуки:
before 'deploy:starting', 'sidekiq:quiet'
after 'deploy:publishing', 'sidekiq:restart'

namespace :deploy do
  desc 'Update Crontab'
  task :crontab do
    on roles([:app, :app_dev]), in: :sequence, wait: 5 do
      within current_path do
        execute :bundle, :exec, :rails, 'tmp:clear'
        execute "touch  #{release_path}/tmp/restart.txt"
        execute :chmod, "u+x bin/rails"
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}  -s environment=#{fetch(:rails_env)}"
      end
    end
  end

  after :publishing, :crontab

  after :updating, :copy_config do
    on roles([:app, :db, :web]) do
      # execute "cp -f #{shared_path}/database.yml #{release_path}/config/"
      # execute "cp -f #{shared_path}/secrets.yml #{release_path}/config/"
    end
  end

  after :crontab, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

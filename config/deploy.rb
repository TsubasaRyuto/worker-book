# config valid only for current version of Capistrano
lock '3.8.2'

set :application, 'workerbook'
set :repo_url, 'git@bitbucket.org:loboinc/worker-book.git'

set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'

set :puma_threads,    [4, 16]
set :puma_workers,    0
set :deploy_to, '/var/www/workerbook'

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

set :linked_files, %w(config/database.yml config/secrets.yml .rbenv-vars)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads)

set :rbenv_type, :system
set :rbenv_ruby, '2.4.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :bundle_path, -> { shared_path.join('vendor/bundle') }
set :bundle_flags, '--deployment'
set :bundle_without, %w(development test).join(' ')

set :assets_roles, :app

set :keep_releases, 3

set :default_env, {
  FOG_DIRECTORY: ENV['FOG_DIRECTORY'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Upload secret files'
  task :upload do
    # Run only Production or Staging
    return true if !fetch(:stage) == 'production' || !fetch(:stage) == 'staging'

    on roles(:app) do |_host|
      execute "mkdir -p #{shared_path}" if test "[ ! -d #{shared_path} ]"

      upload!('config/database.yml', "#{shared_path}/config/database.yml")
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
      rails_env = fetch(:stage)
      upload!("env/#{rails_env}/.rbenv-vars", "#{shared_path}/.rbenv-vars")

      within shared_path do
        execute 'rbenv vars'
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      invoke 'puma:phased-restart'
    end
  end

  after :publishing, :restart
  after :finishing, 'deploy:cleanup'
end

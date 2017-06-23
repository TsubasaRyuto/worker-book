namespace :deploy do
  namespace :asset_sync do
    desc 'Run asset_sync'
    task :run do
      if fetch(:asset_sync_enabled)
        invoke 'deploy:asset_sync:precompile'
        invoke 'deploy:asset_sync:upload_manifest'
        invoke 'deploy:asset_sync:cleanup'

        Rake::Task['deploy:assets:precompile'].clear_actions
      end
    end

    desc 'Run assets:precompile'
    task :precompile do
      run_locally do
        Bundler.with_clean_env do
          execute "bundle exec rake assets:precompile RAILS_ENV=#{fetch(:stage)} ASSET_SYNC_ENABLED=#{fetch(:asset_sync_enabled)}"
        end
      end
    end

    desc 'Upload manifest'
    task :upload_manifest do
      on roles(fetch(:assets_roles)) do
        if test "[ ! -d #{release_path}/public/assets ]"
          execute "mkdir -p #{release_path}/public/assets"
        end
        file_path = Dir::glob('public/assets/.sprockets-manifest*').first
        upload!(file_path, "#{release_path}/public/assets/")
      end
    end

    desc 'Cleanup assets'
    task :cleanup do
      run_locally do
        Bundler.with_clean_env do
          execute "bundle exec rake assets:clobber"
        end
      end
    end
  end
end

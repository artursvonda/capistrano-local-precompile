namespace :load do
  task :defaults do
    set :precompile_cmd, "exec rake assets:precompile"
    set :cleanexpired_cmd, "exec rake assets:clean_expired"
    set :assets_dir, "public/assets"

    set :turbosprockets_enabled, false
    set :turbosprockets_backup_dir, "public/.assets"
    set :rsync_cmd, "rsync -av"

    before "deploy:assets:precompile", "deploy:assets:prepare"
    after "deploy:assets:precompile", "deploy:assets:cleanup"
  end
end

namespace :deploy do
  namespace :assets do

    task :cleanup do
      run_locally do
        if fetch(:turbosprockets_enabled)
          run "mv #{fetch(:assets_dir)} #{fetch(:turbosprockets_backup_dir)}"
        else
          run "rm -rf #{fetch(:assets_dir)}"
        end
      end
    end

    task :prepare do
      run_locally do
        if fetch(:turbosprockets_enabled)
          run "mkdir -p #{fetch(:turbosprockets_backup_dir)}"
          run "mv #{fetch(:turbosprockets_backup_dir)} #{fetch(:assets_dir)}"
          execute :bundle, fetch(:cleanexpired_cmd)
        end
        execute :bundle, fetch(:precompile_cmd)
      end
    end

    desc "Precompile assets locally and then rsync to app servers"
    task :precompile do
      on hosts do |host|
        upload! "./#{fetch(:assets_dir)}/", "#{release_path}/#{fetch(:assets_dir)}/", recursive: true
      end
    end

  end
end

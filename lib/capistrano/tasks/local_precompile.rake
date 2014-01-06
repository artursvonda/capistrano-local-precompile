namespace :load do
  task :defaults do
    set :precompile_cmd, "assets:precompile"
    set :assets_dir, "public/assets"

    after 'deploy:updating', 'deploy:assets:prepare'
    before 'deploy:updated', 'deploy:assets:precompile'
    after 'deploy:finished', 'deploy:assets:cleanup'
  end
end

namespace :deploy do
  namespace :assets do

    task :cleanup do
      run_locally do
        execute "rm -rf #{fetch(:assets_dir)}"
      end
    end

    task :prepare do
      run_locally do
        old_prefix = nil
        if SSHKit.config.command_map.prefix[:rake].join(' ').include? 'rvm'
          old_prefix = SSHKit.config.command_map.prefix[:rake].clone
          SSHKit.config.command_map.prefix[:rake].clear
        end
        execute :rake, fetch(:precompile_cmd)
        if old_prefix
          SSHKit.config.command_map.prefix[:rake].push *old_prefix
        end
      end
    end

    desc "Precompile assets locally and then rsync to app servers"
    task :precompile do
      on roles(:web) do |host|
        upload! "#{ fetch :assets_dir }/", "#{ release_path }/#{ fetch :assets_dir }/", recursive: true, verbose: false
      end
    end

  end
end

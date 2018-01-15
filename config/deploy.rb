# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "toy_app"
set :repo_url, "git@github.com:mohd-adib/toy_app.git"
set :rails_env, 'production'
server '35.197.136.5', user: "root", roles: %w{app db web}, primary: true
set :deploy_to,       "/home/deployer/apps/#{fetch(:application)}"
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :config_example_suffix, '.example'
set :config_files, %w{config/database.yml config/secrets.yml}
set :puma_conf, "#{shared_path}/config/puma.rb"
set :rvm_map_bins, %w{gem rake ruby rails bundle puma pumactl}
set :rvm_ruby_version, '2.5.0'
set :format_options, log_file: "storage/logs/capistrano.log"

namespace :logs do
  desc "tail rails logs" 
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

namespace :deploy do
  before 'check:linked_files', 'config:push'
  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  before 'deploy:migrate', 'deploy:db:create'
  after 'puma:smart_restart', 'nginx:restart'
end
# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "toy_app"
set :repo_url, "git@github.com:mohd-adib/toy_app.git"
set :rails_env, 'production'
server '35.198.205.200', user: "deployer", roles: %w{app db web}, primary: true
set :deploy_to,       "/home/deployer/apps/#{fetch(:application)}"
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :config_example_suffix, '.example'
set :config_files, %w{config/database.yml config/secrets.yml}
set :puma_conf, "#{shared_path}/config/puma.rb"

before "deploy:starting", "deploy:setup_maintenance_for_deploy"
before "deploy:starting", "maintenance:enable"
# after 'deploy:migrate', 'deploy:seed'
after 'deploy:publishing', 'deploy:restart'
after "deploy:finished", "maintenance:disable"

namespace :deploy do
  before 'check:linked_files', 'config:push'
  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  before 'deploy:migrate', 'deploy:db:create'
  after 'puma:smart_restart', 'nginx:restart'
end
# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "linx"
set :repo_url, "git@github.com:felipegirotti/node-deploy.git"

set :deploy_to, "/var/projects/linx"
set :main_js, "app.js"
set :ssh_options, { :forward_agent => true }

set :linked_dirs, %w(
  node_modules
)

set :keep_releases, 5

namespace :deploy do
    desc "ReStart app per CPU"
    task :start_apps do
      on roles(:app) do
        execute "sudo start-apps"
      end
    end
end

after "deploy:symlink:release", "deploy:start_apps"
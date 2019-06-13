def _default_stage
  fetch(:default_stage, 'staging')
end

def _default_stages
  fetch(:stages, %w(staging production))
end

def _stages_dir
  fetch(:stages_dir, 'config/deploy')
end

def _all_stages_empty?
  !fetch(:all_stages, nil)
end

def _file_for_stage(stage_name)
  File.join(_stages_dir, "#{stage_name}.rb")
end

def _stage_file_exists?(stage_name)
  File.exists?(File.expand_path(_file_for_stage(stage_name)))
end

def _get_all_stages
  Dir["#{_stages_dir}/*.rb"].reduce([]) { |all_stages, file| all_stages << File.basename(file, '.rb') }
end

def _default_apps
  fetch(:hanami_apps)
end

def _get_all_apps
  apps = []
  _get_all_stages.each do |stage|
    apps << Dir["#{_stages_dir}/#{stage}/*.rb"].reject{ |file| File.basename(file, '.rb') == stage }.reduce([]) { |all_apps, file| all_apps << File.basename(file, '.rb') }
  end
  apps.flatten.uniq
end

def _apps_empty?
  !fetch(:all_apps, nil)
end

def _app_file_in_stage_exists?(stage_name, app_name)
  File.exists?(File.join(_stages_dir, stage_name, "#{app_name}.rb"))
end

def _file_for_app_in_stage(stage_name, app_name)
  File.join(_stages_dir, stage_name, "#{app_name}.rb")
end

def _argument_included_in_stages?(arg)
  fetch(:all_stages).include?(arg)
end

def _argument_included_in_apps?(arg)
  fetch(:all_apps).include?(arg)
end

set :all_stages, _get_all_stages if _all_stages_empty?
set :all_apps, _get_all_apps if _apps_empty?

fetch(:all_stages).each do |stage_name|
  desc "Set the target stage to '#{stage_name}'."
  task(stage_name) do
    set :current_stage, stage_name
    file = "#{_stages_dir}/#{fetch(:current_stage)}.rb"
    load file
  end
end

fetch(:all_apps).each do |app_name|
  desc "Set the target app to '#{app_name}'."
  task(app_name) do
    set :current_app, app_name
    file = "#{_stages_dir}/#{fetch(:current_stage)}/#{fetch(:current_app)}.rb"
    load file
  end
end

_potential_stage = ARGV.first

if !_stage_file_exists?(_potential_stage) && _stage_file_exists?(_default_stage)
  invoke _default_stage
end

namespace :proteus do
  desc 'Create stage and apps files'
  task :init do
    ensure!(:hanami_apps)
    FileUtils.mkdir_p _stages_dir if !File.exists? _stages_dir
    _default_stages.each do |stage|
      FileUtils.mkdir_p File.join(_stages_dir, stage) if !File.exists? File.join(_stages_dir, stage)
      stagefile = _file_for_stage(stage)
      if !_stage_file_exists?(stage)
        puts "Creating #{stagefile}"
        File.open(stagefile, 'w') do |f|
          f.puts "set :hanami_env, '#{stage}'"
          f.puts "set :rack_env, 'fetch(:hanami_env)'"
          f.puts "set :domain, '127.0.0.1'"
          f.puts "set :repository, 'username@repo.com:project/project.git'"
          f.puts "set :branch, 'tree_branch'"
          f.puts "set :user, 'your_user'"
        end
      else
        puts "Skipping #{stagefile}, it already exists"
      end

      _default_apps.each do |app|
        appfile = _file_for_app_in_stage(stage, app)
        if !_app_file_in_stage_exists?(stage, app)
        puts "  Creating #{appfile}"
        File.open(appfile, 'w') do |f|
          f.puts "set :deploy_to, '/your/remote/dir'"
          f.puts "set :hanami_app, '#{app}'"
        end
      else
        puts "  Skipping #{appfile}, it already exists"
      end
      end
    end
  end
end
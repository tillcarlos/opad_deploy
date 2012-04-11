set :application, "OPAD"
conf = @settings


set :user,  conf['ssh_user']
ssh_options[:port] =  conf['ssh_port']
set :ssh_options, { :forward_agent => true }

set :deploy_to, conf['deploy_to']


role :web, conf['server'], :primary => true
role :app, conf['server']
role :db,  conf['server']

set :repository,  conf['cache_path']
set :scm, :git
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
set :deploy_via, :rsync_with_remote_cache


namespace :opad do
  task :build do
    # Please provide the following structure for building OPAD
    # opad
    # tslib
    # autodeploy (this folder)
    puts "Building TSLib"
    local_exec "cd #{conf['tslib_path']}/ && ant && cp dist/tslib.jar #{conf['opad_path']}lib/"

    puts "Building OPAD"
    local_exec "cd #{conf['opad_path']} && ant && cp dist/kieker.opad.jar #{conf['cache_path']} "
  end
  
  task :upload do
    puts "Uploading the cache path to #{deploy_to}"
    #upload("#{conf['cache_path']}", "#{deploy_to}", :via => :scp, :recursive => true) 
  end
  
      
end


def local_exec cmd
  puts "Executing #{cmd}"
  system " #{cmd} "
  true
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :application, "OPAD"
conf = $config


set :user,  conf[:server]['ssh_user']
ssh_options[:port] =  conf[:server]['ssh_port']
set :ssh_options, { :forward_agent => true }

set :deploy_to, conf[:server]['deploy_to']


role :web, conf[:server]['host'], :primary => true
role :app, conf[:server]['host']
role :db,  conf[:server]['host']

set :repository,  conf[:local]['cache_path']
set :scm, :git
set :copy_exclude, [".git", ".git/*", ".DS_Store", ".gitignore", ".gitmodules"]
set :deploy_via, :rsync_with_remote_cache


namespace :opad do
  task :build do
    puts "Building TSLib"
    local_exec "cd #{conf[:local]['tslib_path']} && ant && cp dist/tslib.jar #{conf[:local]['opad_path']}lib/"

    puts "Building OPAD"
    local_exec "cd #{conf[:local]['opad_path']} && ant"
  end
  
  task :bundle do
    # Please provide the following structure for building OPAD
    # opad
    # tslib
    # opad_deploy (this folder)
    puts "Cleaning the cache dir"
    local_exec "rm -rf #{conf[:local]['cache_path']}*"
    local_exec "mkdir -p #{conf[:local]['cache_path']}opad/lib/"
    local_exec "mkdir -p #{conf[:local]['cache_path']}support/"
    local_exec "mkdir -p #{conf[:local]['cache_path']}graph/"
    local_exec "mkdir -p #{conf[:local]['cache_path']}common/"
    local_exec "mkdir -p #{conf[:local]['cache_path']}daemons/"
    
    local_exec "cp #{conf[:local]['opad_path']}build.xml* #{conf[:local]['cache_path']}opad/lib/ "
    local_exec "cp #{conf[:local]['opad_path']}lib/* #{conf[:local]['cache_path']}opad/lib/ "
    local_exec "cp #{conf[:local]['opad_path']}dist/kieker.opad.jar #{conf[:local]['cache_path']}opad/lib/ "
    
    puts "Copying Graph Frontend"
    local_exec "cp -r #{conf[:local]['graph_path']} #{conf[:local]['cache_path']}graph "

    puts "Copying Support Scripts"
    local_exec "cp -r #{conf[:local]['support_path']} #{conf[:local]['cache_path']}support "
    
    puts "Copy the local settings. Those will be used on the server as well!"
    local_exec "cp -r ./common/ #{conf[:local]['cache_path']}common "
    
    puts "Copying the daemons. Take care not to change the PIDs. This should be changed to a more stable approach later!"
    local_exec "cp -r ./daemons/* #{conf[:local]['cache_path']}daemons "
    
    puts "Commiting cache dir to git (capistrano needs it)."
    local_exec "cd #{conf[:local]['cache_path']} && git add . && git commit -a -m 'opad_deploy at #{Time.now}'  "
  end
  
  task :all do
    puts "Building, bundling and deploying opad!"
  end
  after "opad:all", "opad:build"
  after "opad:all", "opad:bundle"
  after "opad:all", "deploy"
  
end

namespace :customs do
  task :deletegitfolder, :roles => :app do
    # a workaround. somehow, the line in the head does not work
    # (set :copy_exclude, [".git", ".git/*", ".DS_Store", ".gitignore", ".gitmodules"])
    run "rm -rf  #{release_path}/.git "
  end
  task :config, :roles => :app do
    %w(graph kieker sleepy_mongoose websocket anomalyscore_generator).each do |daemon|
      run "rm -f #{shared_path}/daemons/#{daemon}.daemon.sh "
      run "ln -s #{current_path}/daemons/#{daemon}.rb #{shared_path}/daemons/#{daemon}.daemon.sh  "
    end
  end
end
after "deploy:update_code", "customs:config"
after "deploy:update_code", "customs:deletegitfolder"
  
  

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

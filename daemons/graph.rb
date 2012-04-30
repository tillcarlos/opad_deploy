#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler.require(:default, :graph)


$opad_home ||= ENV['OPAD_HOME']
puts "Starting graph deamon with $opad_home=#{$opad_home}"
require File.join($opad_home, 'common', 'read_config')


shared_path = "/srv/opad/shared/"
graph_folder = "/srv/opad/current/graph/"
cmd_and_params = "thin -R #{graph_folder}config.ru start -p #{$config[:graph]['web_port']}"
ap "Executing: #{cmd_and_params} as a daemon."

pwd = Dir.pwd
Daemons.run_proc('graph.rb', {:dir_mode => :normal, :dir => $config[:daemons]['pid_folder']}) do
  Dir.chdir(pwd)
  exec cmd_and_params
end




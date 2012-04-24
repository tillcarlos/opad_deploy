#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler.require(:default)

$opad_home ||= ENV['OPAD_HOME']
puts "Starting kieker deamon with $opad_home=#{$opad_home}"
require File.join($opad_home, 'common', 'read_config')


kieker_lib = "/srv/opad/current/opad/lib/"
shared_path = "/srv/opad/shared/"
log4j_conf = File.join($opad_home, 'common', 'log4j.properties')
opad_conf = File.join($opad_home, 'common', 'opad.conf.yml')
cmd_and_params = "cd #{kieker_lib} && java -Dlog4j.configuration=file:#{log4j_conf} -Dopad.config.file=#{opad_conf} -jar kieker.opad.jar"
ap "Executing: #{cmd_and_params} as a daemon."

Daemons.run_proc("opad", {:dir_mode => :normal, :dir => "#{shared_path}pids/"}) do
  exec cmd_and_params
end



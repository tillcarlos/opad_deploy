#!/usr/bin/env ruby
# encoding: utf-8

scriptname = "websocket.rb"


require 'rubygems'
require 'bundler'
Bundler.require(:default)


$opad_home ||= ENV['OPAD_HOME']
puts "Starting #{scriptname} deamon with $opad_home=#{$opad_home}"
require File.join($opad_home, 'common', 'read_config.rb')

command = File.join($opad_home, 'support', scriptname)

ap "Executing: #{command} as a daemon. Scriptname: #{scriptname}"
Daemons.run_proc(scriptname, {:dir_mode => :normal, :dir => $config[:daemons]['pid_folder']}) do
  exec command
end

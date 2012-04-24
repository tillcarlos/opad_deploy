require 'bundler'
Bundler.require(:default)

load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

$opad_home ||= File.expand_path(File.join(File.dirname(__FILE__), 'common'))
require File.join($opad_home, 'read_config')

load 'config/deploy' # remove this line to skip loading any of the default tasks
require 'bundler'
Bundler.require(:default)

load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }


# This code exits if the settings are not provided in a proper way
# (It's not the best pattern to handle error, please refactor.)
begin
  settingsfile = "settings.yml"
  opadcon = Hash[YAML::load(open(settingsfile)).map { |k, v| [k.to_sym, v] }]
  @settings = opadcon[:opad]
  puts "Deploying OPAD with configuration:"
  ap @settings
rescue => e
  puts "Please provide a valid configuration! See settings.sample.yml for template!"
  exit 0
end


load 'config/deploy' # remove this line to skip loading any of the default tasks
def read_config settingsfile
  settings = {}
  begin
    puts "Reading config from #{settingsfile}"
    settings = Hash[YAML::load(open(settingsfile)).map { |k, v| [k.to_sym, v] }]
  rescue => e
    puts "Please provide a valid configuration! See the template! Error: #{e}"
  end
  settings
end

$config = read_config File.expand_path(File.join(File.dirname(__FILE__), "settings.yml")) 
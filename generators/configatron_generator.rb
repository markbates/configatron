require 'rails_generator'
class ConfigatronGenerator < Rails::Generator::Base # :nodoc:
  
  def manifest
    record do |m|
      m.directory 'config/configatron'
      m.directory 'config/configatron/development'
      m.directory 'config/configatron/test'
      m.directory 'config/configatron/production'
      m.directory 'config/configatron/cucumber'
      m.file 'initializers/configatron.rb', 'config/initializers/configatron.rb'
      m.file 'configatron/development.rb', 'config/configatron/development.rb'
      m.file 'configatron/production.rb', 'config/configatron/production.rb'
      m.file 'configatron/test.rb', 'config/configatron/test.rb'
      m.file 'configatron/cucumber.rb', 'config/configatron/cucumber.rb'
      m.file 'configatron/defaults.rb', 'config/configatron/defaults.rb'
    end
  end
  
end # ConfigatronGenerator
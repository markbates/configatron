# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "configatron"
  s.version = "2.9.0.20111208155705"

  s.authors = ["markbates"]
  s.description = "configatron was developed by: markbates"
  s.email = "mark@markbates.com"
  s.files = ["lib/configatron/configatron.rb", "lib/configatron/core_ext/class.rb", "lib/configatron/core_ext/kernel.rb", "lib/configatron/core_ext/object.rb", "lib/configatron/core_ext/string.rb", "lib/configatron/errors.rb", "lib/configatron/proc.rb", "lib/configatron/rails.rb", "lib/configatron/store.rb", "lib/configatron.rb", "lib/generators/configatron/install/install_generator.rb", "lib/generators/configatron/install/templates/configatron/defaults.rb", "lib/generators/configatron/install/templates/configatron/development.rb", "lib/generators/configatron/install/templates/configatron/production.rb", "lib/generators/configatron/install/templates/configatron/test.rb", "lib/generators/configatron/install/templates/initializers/configatron.rb", "README.textile", "LICENSE"]
  s.homepage = "http://www.metabates.com"
  s.require_paths = ["lib"]
  s.summary = "A powerful Ruby configuration system."

  s.add_runtime_dependency "yamler", ">= 0.1.0"
end

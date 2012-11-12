# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configatron/version'

Gem::Specification.new do |gem|
  gem.name          = "configatron"
  gem.version       = Configatron::VERSION
  gem.authors       = ["Mark Bates"]
  gem.email         = ["mark@markbates.com"]
  gem.description   = %q{A powerful Ruby configuration system.}
  gem.summary       = %q{A powerful Ruby configuration system.}
  gem.homepage      = "http://www.metabates.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("yamler", ">= 0.1.0")
end



# # -*- encoding: utf-8 -*-
# require File.expand_path('../lib/configatron/version', __FILE__)

# Gem::Specification.new do |s|
#   s.name = "configatron"
#   s.version = Configatron::VERSION

#   s.authors = ["markbates"]
#   s.description = "configatron was developed by: markbates"
#   s.email = "mark@markbates.com"
#   s.extra_rdoc_files = ["LICENSE"]

#   ignored_files = File.read('.gitignore').split("\n").compact.reject(&:empty?) + ["Rakefile", "Gemfile", "configatron.gemspec"]
#   test_files = Dir['spec/**/*'].reject {|f| File.directory?(f)}
#   library_files = Dir['**/*'].reject{|f| File.directory?(f)}
#   s.files = library_files - test_files - ignored_files
#   s.homepage = "http://www.metabates.com"
#   s.require_paths = ["lib"]
#   s.summary = "A powerful Ruby configuration system."

#   s.add_runtime_dependency "yamler", ">= 0.1.0"
#   s.add_development_dependency 'rake'
#   s.add_development_dependency 'rspec'
#   s.add_development_dependency 'gemstub'
# end

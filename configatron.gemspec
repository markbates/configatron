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
  gem.homepage      = "https://github.com/markbates/configatron"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "subprocess"
  gem.add_development_dependency "minitest", '>=5.2.3'
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/configatron/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "configatron"
  s.version = Configatron::VERSION

  s.authors = ["markbates"]
  s.description = "configatron was developed by: markbates"
  s.email = "mark@markbates.com"
  s.extra_rdoc_files = ["LICENSE"]

  ignored_files = File.read('.gitignore').split("\n").compact.reject(&:empty?) + ["Rakefile", "Gemfile", "configatron.gemspec"]
  test_files = Dir['spec/**/*'].reject {|f| File.directory?(f)}
  library_files = Dir['**/*'].reject{|f| File.directory?(f)}
  s.files = library_files - test_files - ignored_files
  s.homepage = "http://www.metabates.com"
  s.require_paths = ["lib"]
  s.summary = "A powerful Ruby configuration system."

  s.add_runtime_dependency "yamler", ">= 0.1.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'gemstub'
end

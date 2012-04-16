# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "configatron"
  s.version = "2.9.0.20111208155705"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = "2011-12-08"
  s.description = "configatron was developed by: markbates"
  s.email = "mark@markbates.com"
  s.extra_rdoc_files = ["LICENSE"]

  ignored_files = File.read('.gitignore').split("\n").compact.reject(&:empty?) + ["Rakefile", "Gemfile", "configatron.gemspec"]
  test_files = Dir['spec/**/*'].reject {|f| File.directory?(f)}
  library_files = Dir['**/*'].reject{|f| File.directory?(f)}
  s.files = library_files - test_files - ignored_files
  s.homepage = "http://www.metabates.com"
  s.require_paths = ["lib"]
  s.rubyforge_project = "magrathea"
  s.rubygems_version = "1.8.10"
  s.summary = "A powerful Ruby configuration system."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<yamler>, [">= 0.1.0"])
    else
      s.add_dependency(%q<yamler>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<yamler>, [">= 0.1.0"])
  end
end

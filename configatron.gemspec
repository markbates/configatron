# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{configatron}
  s.version = "2.3.0.20090422140433"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2009-04-22}
  s.description = %q{Configatron was developed by: markbates}
  s.email = %q{mark@mackframework.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["lib/configatron/configatron.rb", "lib/configatron/core_ext/class.rb", "lib/configatron/core_ext/kernel.rb", "lib/configatron/core_ext/object.rb", "lib/configatron/core_ext/string.rb", "lib/configatron/errors.rb", "lib/configatron/store.rb", "lib/configatron.rb", "README"]
  s.has_rdoc = true
  s.homepage = %q{http://www.mackframework.com}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A powerful Ruby configuration system.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<yamler>, [">= 0.1.0"])
    else
      s.add_dependency(%q<yamler>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<yamler>, [">= 0.1.0"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{configatron}
  s.version = "2.8.0.20110520095417"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{markbates}]
  s.date = %q{2011-05-20}
  s.description = %q{configatron was developed by: markbates}
  s.email = %q{mark@markbates.com}
  s.extra_rdoc_files = [%q{LICENSE}]
  s.files = [%q{lib/configatron/configatron.rb}, %q{lib/configatron/core_ext/class.rb}, %q{lib/configatron/core_ext/kernel.rb}, %q{lib/configatron/core_ext/object.rb}, %q{lib/configatron/core_ext/string.rb}, %q{lib/configatron/errors.rb}, %q{lib/configatron/proc.rb}, %q{lib/configatron/rails.rb}, %q{lib/configatron/store.rb}, %q{lib/configatron.rb}, %q{README}, %q{LICENSE}, %q{generators/configatron_generator.rb}, %q{generators/templates/configatron/cucumber.rb}, %q{generators/templates/configatron/defaults.rb}, %q{generators/templates/configatron/development.rb}, %q{generators/templates/configatron/production.rb}, %q{generators/templates/configatron/test.rb}, %q{generators/templates/initializers/configatron.rb}]
  s.homepage = %q{http://www.metabates.com}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.8.2}
  s.summary = %q{A powerful Ruby configuration system.}

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

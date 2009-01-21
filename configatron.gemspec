# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{configatron}
  s.version = "2.2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2009-01-20}
  s.description = %q{Configatron was developed by: markbates}
  s.email = %q{mark@mackframework.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["lib/configatron/blank_slate.rb", "lib/configatron/configatron.rb", "lib/configatron/core_ext/class.rb", "lib/configatron/core_ext/kernel.rb", "lib/configatron/core_ext/object.rb", "lib/configatron/core_ext/string.rb", "lib/configatron/errors.rb", "lib/configatron/store.rb", "lib/configatron.rb", "README", "spec/lib", "spec/lib/blank_slate_spec.rb", "spec/lib/class_spec.rb", "spec/lib/configatron_spec.rb", "spec/lib/errors_spec.rb", "spec/lib/futurama.yml", "spec/lib/lost.yml", "spec/lib/store_spec.rb", "spec/lib/the_wire.yml", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.mackframework.com}
  s.require_paths = ["lib", "lib"]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A powerful Ruby configuration system.}
  s.test_files = ["spec/lib", "spec/lib/blank_slate_spec.rb", "spec/lib/class_spec.rb", "spec/lib/configatron_spec.rb", "spec/lib/errors_spec.rb", "spec/lib/futurama.yml", "spec/lib/lost.yml", "spec/lib/store_spec.rb", "spec/lib/the_wire.yml", "spec/spec.opts", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

require 'rubygems'
require 'gemstub'

Gemstub.test_framework = :rspec

Gemstub.gem_spec do |s|
  s.version = "2.5.1"
  s.summary = "A powerful Ruby configuration system."
  s.rubyforge_project = "magrathea"
  s.add_dependency('yamler', '>=0.1.0')
  s.email = 'mark@markbates.com'
  s.homepage = 'http://www.metabates.com'
  s.files = FileList['lib/**/*.*', 'README', 'LICENSE', 'bin/**/*.*', 'generators/**/*.*']
end

Gemstub.rdoc do |rd|
  rd.title = "Configatron"
end
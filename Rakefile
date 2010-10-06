require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

Bundler.require

Gemstub.test_framework = :rspec

Gemstub.gem_spec do |s|
  s.version = "2.6.4"
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
require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'gemstub'

Gemstub.test_framework = :rspec

# Gemstub.gem_spec do |s|
#   s.version = "2.9.0"
#   s.summary = "A powerful Ruby configuration system."
#   s.rubyforge_project = "magrathea"
#   s.add_dependency('yamler', '>=0.1.0')
#   s.email = 'mark@markbates.com'
#   s.homepage = 'http://www.metabates.com'
#   s.files = FileList['lib/**/*.*', 'README.textile', 'LICENSE', 'bin/**/*.*']
# end

# Gemstub.rdoc do |rd|
#   rd.title = "Configatron"
# end
require 'rubygems'
# require 'spec'
gem 'spicycode-micronaut'
gem 'relevance-log_buddy'
require 'micronaut'
require 'log_buddy'
LogBuddy.init

Micronaut.configure do |c|
  c.filter_run :focused => true
  c.alias_example_to :fit, :focused => true
end


require File.join(File.dirname(__FILE__), '..', 'lib', 'configatron')
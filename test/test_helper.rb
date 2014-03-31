require 'bundler/setup'

require 'configatron' # and any other gems you need

require 'minitest/autorun'
require "mocha/setup"
require 'mocha/mini_test'

class MiniTest::Spec

  class << self
    alias :context :describe
  end

end

require 'bundler/setup'

require 'configatron' # and any other gems you need

require 'minitest/autorun'
require "minitest-colorize"

class MiniTest::Spec

  class << self
    alias :context :describe
  end

end
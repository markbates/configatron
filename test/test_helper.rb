require 'bundler/setup'

require 'configatron' # and any other gems you need

require 'minitest/autorun'

class MiniTest::Spec

  class << self
    alias :context :describe
  end

end

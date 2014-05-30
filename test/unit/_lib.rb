require File.expand_path('../../_lib', __FILE__)

module Critic::Unit
  module Stubs
  end

  class Test < Critic::Test
    include Stubs
  end
end

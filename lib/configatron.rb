require "configatron/version"
require "configatron/core"
require "configatron/rails"

module Kernel
  def configatron
    @__configatron ||= Configatron::Store.new
  end
end
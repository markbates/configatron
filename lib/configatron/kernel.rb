require 'singleton'
class Configatron::KernelStore
  include ::Singleton

  attr_reader :store

  def initialize
    @store = ::Configatron::Store.new
  end

  def method_missing(name, *args, &block)
    store.send(name, *args, &block)
  end

end

module Kernel
  def configatron
    Configatron::KernelStore.instance
  end
end

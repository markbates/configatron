class Configatron::KernelStore
  include Singleton

  attr_reader :store

  # Have one global KernelStore instance, but allow people to create
  # their own parallel ones if they desire.
  class << self
    public :new
  end

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

require 'singleton'
require 'forwardable'

# This is the root configatron object, and contains methods which
# operate on the entire configatron hierarchy.
class Configatron::RootStore < BasicObject
  include ::Singleton
  extend ::Forwardable

  attr_reader :store

  # Have one global RootStore instance, but allow people to create
  # their own parallel ones if they desire.
  class << self
    public :new
  end

  def initialize
    @locked = false
    reset!
  end

  def method_missing(name, *args, &block)
    store.__send__(name, *args, &block)
  end

  def reset!
    @store = ::Configatron::Store.new(self)
  end

  def temp(&block)
    temp_start

    begin
      yield
    ensure
      temp_end
    end
  end

  def temp_start
    @temp = ::Configatron::DeepClone.deep_clone(@store)
    @temp_locked = @locked
  end

  def temp_end
    @store = @temp
    @locked = @temp_locked
  end

  def locked?
    @locked
  end

  def lock!(&blk)
    if blk
      orig = @locked
      begin
        @locked = true
        blk.call
      ensure
        @locked = orig
      end
    else
      @locked = true
    end
  end

  def unlock!(&blk)
    if blk
      orig = @locked
      begin
        @locked = false
        blk.call
      ensure
        @locked = orig
      end
    else
      @locked = false
    end
  end

  def_delegator :@store, :to_s
  def_delegator :@store, :inspect
end

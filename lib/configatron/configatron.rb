require 'singleton'
require 'logger'

class Configatron
  include Singleton

  alias_method :send!, :send
  
  class << self
    
    def log
      unless @logger
        if defined?(::Rails)
          @logger = ::Rails.logger
        end
        @logger = ::Logger.new(STDOUT) if @logger.nil?
      end
      return @logger
    end
    
  end

  def initialize # :nodoc:
    @_namespace = [:default]
    reset!
  end
  
  # Forwards the method call onto the 'namespaced' Configatron::Store
  def method_missing(sym, *args, &block)
    @_store[@_namespace.last].send(sym, *args, &block)
  end

  # respond_to to respond_to
  def respond_to?(method)
    !@_store[@_namespace.last].send(method).nil? || super
  end

  # Removes ALL configuration parameters
  def reset!
    @_store = {:default => Configatron::Store.new}
  end

  # Allows for the temporary overriding of parameters in a block.
  # Takes an optional Hash of parameters that will be applied before
  # the block gets called. At the end of the block, the temporary
  # settings are deleted and the original settings are reinstated.
  def temp(options = nil)
    begin
      temp_start(options)
      yield @_store[@_namespace.last]
    rescue Exception => e
      raise e
    ensure
      temp_end
    end
  end

  def temp_start(options = nil)
    n_space = rand
    @_store[n_space] = @_store[@_namespace.last].deep_clone
    @_namespace << n_space
    if options
      self.method_missing(:configure_from_hash, options)
    end
  end

  def temp_end
    @_store.delete(@_namespace.pop)
  end

  begin
    undef :inspect # :nodoc:
    undef :nil? # :nodoc:
    undef :test # :nodoc:
  rescue Exception => e
  end


end

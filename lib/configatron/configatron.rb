require 'singleton'

class Configatron
  include Singleton
  
  def initialize # :nodoc:
    @_namespace = :default
    reset!
  end
  
  # Forwards the method call onto the 'namespaced' Configatron::Store
  def method_missing(sym, *args)
    @_store[@_namespace].send(sym, *args)
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
      yield
    rescue Exception => e
      raise e
    ensure
      temp_end
    end
  end
  
  def temp_start(options = nil)
    @_namespace = rand
    @_store[@_namespace] = @_store[:default].deep_clone
    if options
      self.method_missing(:configure_from_hash, options)
    end
  end
  
  def temp_end
    @_store.delete(@_namespace)
    @_namespace = :default
  end
  
  undef :inspect # :nodoc:
  undef :nil? # :nodoc:
  
end
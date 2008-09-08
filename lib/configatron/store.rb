module Configatron
  # Used to store each of the 'sets' of configuration parameters.
  class Store
    include Configatron::Helpers
    
    # The actual key/pair parameter values.
    attr_reader :parameters
  
    # Takes an optional Hash to configure parameters.
    def initialize(parameters = {})
      @parameters = parameters
    end
  
    # If a method is called with an = at the end, then that method name, minus
    # the equal sign is added to the parameter list as a key, and it's *args
    # become the value for that key. Eventually the keys become method names.
    # If a method is called without an = sign at the end then the value from
    # the parameters hash is returned, if it exists.
    def method_missing(sym, *args)
      if sym.to_s.match(/(.+)=$/)
        @parameters[sym.to_s.gsub("=", '').to_sym] = *args
      else
        val = @parameters[sym]
        if val.is_a? Hash
          val = (@parameters[sym] = Configatron::Store.new(val))
        end
        return val unless val.nil?
        return handle_missing_parameter(sym)
      end
    end
    
    # Checks whether or not configuration parameter exists.
    def exists?(name)
      return true unless @parameters[name.to_sym].nil?
      super(name)
    end
    
    # Used to create 'namespaces' around a set of configuration parameters.
    def namespace(name)
      if exists?(name)
        yield self.send(name.to_sym)
      elsif configatron.exists?(name)
        yield configatron.send(name.to_sym)
      else
        ns = Configatron::Store.new
        yield ns
        @parameters[name.to_sym] = ns
      end
    end
    
    # Called when a reload is called on configatron. Useful for subclasses that 
    # may need to read a file in, etc...
    def reload
    end
  
  end # Store
end # Configatron
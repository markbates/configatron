module Configatron
  # Used to store each of the 'sets' of configuration parameters.
  class Store
  
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
        return val unless val.nil? || configatron.nil_for_missing
        raise NoMethodError.new(sym.to_s)
      end
    end
    
    # Used to create 'namespaces' around a set of configuration parameters.
    def namespace(name)
      ns = Configatron::Store.new
      yield ns
      @parameters[name.to_sym] = ns
    end
  
  end # Store
end # Configatron
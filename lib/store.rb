module Configatron
  class Store
  
    attr_reader :parameters
  
    def initialize
      @parameters = {}
    end
  
    def method_missing(sym, *args)
      if sym.to_s.match(/(.+)=$/)
        @parameters[sym.to_s.gsub("=", '').to_sym] = *args
      else
        val = @parameters[sym]
        return val unless val.nil? || configatron.nil_for_missing
        raise NoMethodError.new(sym.to_s)
      end
    end
    
    def namespace(name)
      # ns = Configatron::Namespace.new(name)
      ns = Configatron::Store.new
      yield ns
      @parameters[name.to_sym] = ns
    end
  
  end # Store
end # Configatron
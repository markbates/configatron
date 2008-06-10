module Configatron
  class Store
  
    attr_reader :parameters
  
    def initialize
      @parameters = {}
    end
  
    def method_missing(sym, *args)
      @parameters[sym.to_s.gsub("=", '').to_sym] = *args
    end
  
  end # Store
end # Configatron
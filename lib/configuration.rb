module Configatron
  class Configuration
    include Singleton
  
    def initialize
      @_storage_list = []
      @_nil_for_missing = false
    end
  
    def nil_for_missing
      @_nil_for_missing
    end
  
    def nil_for_missing=(x)
      @_nil_for_missing = x
    end
  
    def configure
      storage = Configatron::Store.new
      yield storage
      @_storage_list << storage
      storage.parameters.each do |k,v|
        Configatron::Configuration.instance_eval do
          define_method(k) do
            v
          end
        end
      end
    end
  
    def reset!
      @_storage_list.each do |storage|
        storage.parameters.each do |k,v|
          Configatron::Configuration.instance_eval do
            begin
              undef_method(k)
            rescue NameError => e
            end
          end
        end
      end
      @_nil_for_missing = false
    end
  
    def method_missing(sym, *args)
      if self.nil_for_missing
        return nil
      else
        raise NoMethodError.new(sym.to_s)
      end
    end
    
  end # Configuration
end # Configatron
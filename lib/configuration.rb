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
      load_methods(storage)
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
    
    private
    def load_methods(store)
      store.parameters.each do |k,v|
        if k.is_a?(Configatron::Store)
          load_methods(k)
        else
          Configatron::Configuration.instance_eval do
            define_method(k) do
              v
            end
          end
        end
      end
    end
    
  end # Configuration
end # Configatron
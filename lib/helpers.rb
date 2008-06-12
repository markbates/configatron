module Configatron
  module Helpers
    
    def exists?(name)
      self.respond_to?(name)
    end
    
    def handle_missing_parameter(param)
      if configatron.nil_for_missing
        return nil
      else
        raise NoMethodError.new(param.to_s)
      end
    end
    
    def retrieve(name, default_value = nil)
      return self.send(name) if exists?(name)
      return default_value unless default_value.nil?
      handle_missing_parameter(name)
    end
    
  end # Helpers
end # Configatron 
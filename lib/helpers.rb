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
    
  end # Helpers
end # Configatron 
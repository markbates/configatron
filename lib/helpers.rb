module Configatron
  module Helpers
    
    # Checks whether or not configuration parameter exists.
    def exists?(name)
      self.respond_to?(name)
    end
    
    def handle_missing_parameter(param) # :nodoc:
      if configatron.nil_for_missing
        return nil
      else
        raise NoMethodError.new(param.to_s)
      end
    end
    
    # Retrieves the specified config parameter. An optional second
    # parameter can be passed that will be returned if the config
    # parameter doesn't exist.
    def retrieve(name, default_value = ArgumentError)
      return self.send(name) if exists?(name)
      return default_value unless default_value == ArgumentError
      handle_missing_parameter(name)
    end
    
  end # Helpers
end # Configatron 
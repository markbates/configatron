module Configatron
  module Helpers
    
    def exists?(name)
      self.respond_to?(name)
    end
    
  end # Helpers
end # Configatron 
require File.join(File.dirname(__FILE__), 'store')
module Configatron
  # Used to store each of the 'sets' of configuration parameters that came from a YAML file.
  class YamlStore < Configatron::Store
    
    attr_accessor :file_location
    
    # Takes the full path to the YAML file.
    def initialize(file_location)
      super(params_from_yaml(file_location))
      @file_location = file_location
    end
    
    # Re-reads the YAML file.
    def reload
      if self.file_location
        params_from_yaml(self.file_location)
      end
    end
    
    private
    def params_from_yaml(file_location)
      begin
        @parameters = YAML.load(File.read(file_location))
        return @parameters
      rescue Errno::ENOENT => e
        puts e
      end
      return {}
    end
    
  end
end
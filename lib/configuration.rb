module Configatron
  # The central class for managing the configurations.
  class Configuration
    include Singleton
    include Configatron::Helpers
  
    # If nil_for_missing is set to true nil will be returned if the configuration
    # parameter doesn't exist. If set to false, default, then a NoMethodError exception
    # will be raised.
    attr_accessor :nil_for_missing
  
    def initialize # :nodoc:
      @_storage_list = []
      @_nil_for_missing = false
    end
  
    # Yields a new Configatron::Store class.
    def configure
      storage = Configatron::Store.new
      yield storage
      unless storage.parameters.empty?
        @_storage_list << storage
        load_methods(storage)
      end
    end
    
    # Used to load configuration settings from a Hash.
    def configure_from_hash(parameters)
      storage = Configatron::Store.new(parameters)
      @_storage_list << storage
      load_methods(storage)
    end
    
    # Used to load configuration settings from a YAML file.
    def configure_from_yaml(path)
      begin
        configure_from_hash(YAML.load(File.open(path)))
      rescue Errno::ENOENT => e
        puts e.message
        # file doesn't exist.
      end
    end
    
    # Replays the history of configurations.
    def reload
      @_storage_list.each do |storage|
        load_methods(storage)
      end
    end
  
    # Does a hard reset of the Configatron::Configuration class. 
    # All methods are undefined, the list of configuration parameters
    # is emptied, and the nil_for_missing method gets reset to false.
    def reset!
      reset
      self.nil_for_missing = false
      @_storage_list = []
    end
    
    # All methods are undefined.
    def reset
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
    end
    
    # Peels back n number of configuration parameters.
    def revert(step = 1)
      reset
      step.times {@_storage_list.pop}
      reload
    end
  
    def method_missing(sym, *args) # :nodoc:
      handle_missing_parameter(sym)
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
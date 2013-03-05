class Configatron
  # Helpful for making using configatron with Rack apps even easier!
  module Rack

    # Loads configatron files in the following order:
    #
    # Example:
    #   <root>/config/configatron/defaults.rb
    #   <root>/config/configatron/ENV['RACK_ENV'].rb
    #   # optional:
    #   <root>/config/configatron/ENV['RACK_ENV']/defaults.rb
    #   <root>/config/configatron/ENV['RACK_ENV']/bar.rb
    #   <root>/config/configatron/ENV['RACK_ENV']/foo.rb
    #
    #   If you pass in root, it has to be the configatron directory and not the root
    #   of the rack app!
    def self.init(root = nil, env = nil)
      base_dir = root
      if root.nil?
        root = FileUtils.pwd
        base_dir = File.expand_path(File.join(root, 'config', 'configatron'))
      end

      if env.nil?
        env = ENV['RACK_ENV'] || 'development'
      end
      Configatron::ConfigFiles.load(env, base_dir)
    end
  end # Rack
end # Configatron


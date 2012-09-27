class Configatron
  # Helpful for making using configatron with Rack even easier!
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
    def self.init(root = nil, env = nil)
      base_dir = root
      if root.nil?
        root = FileUtils.pwd
        base_dir = File.expand_path(File.join(root, 'config', 'configatron'))
      end

      if env.nil?
        env = ENV['RACK_ENV'] || 'development'
      end

      config_files = []

      config_files << File.join(base_dir, 'defaults.rb')
      config_files << File.join(base_dir, "#{env}.rb")

      env_dir = File.join(base_dir, env)
      config_files << File.join(env_dir, 'defaults.rb')

      Dir.glob(File.join(env_dir, '*.rb')).sort.each do |f|
        config_files << f
      end

      config_files.collect! {|config| File.expand_path(config)}.uniq!

      config_files.each do |config|
        if File.exists?(config)
          require config
        end
      end
    end
  end # Rack
end # Configatron


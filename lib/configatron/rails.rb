class Configatron
  # Helpful for making using configatron with Rails even easier!
  # 
  # To get started you can use the generator to generate
  # the necessary stub files.
  # 
  #   $ ruby script/generate configatron
  module Rails
    
    # Loads configatron files in the following order:
    # 
    # Example:
    #   <RAILS_ROOT>/config/configatron/defaults.rb
    #   <RAILS_ROOT>/config/configatron/<RAILS_ENV>.rb
    #   # optional:
    #   <RAILS_ROOT>/config/configatron/<RAILS_ENV>/defaults.rb
    #   <RAILS_ROOT>/config/configatron/<RAILS_ENV>/bar.rb
    #   <RAILS_ROOT>/config/configatron/<RAILS_ENV>/foo.rb
    def self.init(root = RAILS_ROOT)
      config_files = []

      base_dir = File.expand_path(File.join(root, 'config', 'configatron'))
      config_files << File.join(base_dir, 'defaults.rb')
      config_files << File.join(base_dir, "#{RAILS_ENV}.rb")

      env_dir = File.join(base_dir, RAILS_ENV)
      config_files << File.join(env_dir, 'defaults.rb')

      Dir.glob(File.join(env_dir, '*.rb')).sort.each do |f|
        config_files << f
      end

      config_files.collect! {|config| File.expand_path(config)}.uniq!

      config_files.each do |config|
        if File.exists?(config)
          # puts "Configuration: #{config}"
          require config
        end
      end
    end
    
  end # Rails
end # Configatron
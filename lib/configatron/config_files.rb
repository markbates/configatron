class Configatron
  module ConfigFiles
    class << self
      def load(env, base_dir)
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
            # puts "Configuration: #{config}"
            require config
          end
        end
      end
    end
  end
end

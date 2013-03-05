class Configatron
  # Helpful for making using configatron with Rails even easier!
  #
  # To get started you can use the generator to generate
  # the necessary stub files.
  #
  #   $ ruby script/generate configatron
  module Rails
    class << self
      # Loads configatron files in the following order:
      #
      # Example:
      #   <Rails.root>/config/configatron/defaults.rb
      #   <Rails.root>/config/configatron/<Rails.env>.rb
      #   # optional:
      #   <Rails.root>/config/configatron/<Rails.env>/defaults.rb
      #   <Rails.root>/config/configatron/<Rails.env>/bar.rb
      #   <Rails.root>/config/configatron/<Rails.env>/foo.rb
      def init(root = nil, env = nil)
        base_dir = root
        if root.nil?
          root = defined?(Rails) ? ::Rails.root : FileUtils.pwd
          base_dir = File.expand_path(File.join(root, 'config', 'configatron'))
        end

        if env.nil?
          env = defined?(Rails) ? ::Rails.env : 'development'
        end
        Configatron::ConfigFiles.load(env, base_dir)
      end
    end
  end # Rails
end # Configatron

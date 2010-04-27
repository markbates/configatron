require File.dirname(__FILE__) + '/../spec_helper'

describe Configatron::Rails do
  
  %w{development test production cucumber}.each do |env|
    
    describe env do
      
      before(:each) do
        Object.send(:remove_const, 'Rails') rescue nil
        load File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'rails.rb'))
        ::Rails.env = env
        ::Rails.root = File.join(File.dirname(__FILE__), '..', "tmp_rails_root_#{env}")
        @configatron_path = File.join(Rails.root, 'config', 'configatron')
        @defaults_file_loc = File.join(@configatron_path, 'defaults.rb')
        @env_file_loc = File.join(@configatron_path, "#{env}.rb")
        @env_folder_loc = File.join(@configatron_path, env)
        @env_bar_loc = File.join(@env_folder_loc, 'bar.rb')
        @env_foo_loc = File.join(@env_folder_loc, 'foo.rb')

        FileUtils.mkdir_p(@env_folder_loc)

        File.open(@defaults_file_loc, 'w') do |f|
          f.puts 'configatron.fooa = :foo'
          f.puts 'configatron.bara = :bar'
          f.puts 'configatron.env = :default'
          f.puts 'configatron.something.else = 1'
          f.puts 'configatron.and.another.thing = 42'
        end

        File.open(@env_file_loc, 'w') do |f|
          f.puts "configatron.env = :#{env}"
          f.puts 'configatron.something.else = 2'
        end

        File.open(@env_bar_loc, 'w') do |f|
          f.puts "configatron.bara = 'BAR!!'"
          f.puts 'configatron.something.else = 3'
        end

        File.open(@env_foo_loc, 'w') do |f|
          f.puts "configatron.fooa = :fubar"
          f.puts 'configatron.something.else = 4'
        end
      end

      after(:each) do
        FileUtils.rm_rf(::Rails.root)
        Object.send(:remove_const, 'Rails')
        # configatron.reset!
      end

      it 'should read the defaults first and then the env file' do
        Configatron::Rails.init
        configatron.fooa.should == :fubar
        configatron.bara.should == 'BAR!!'
        configatron.env.should == env.to_sym
        configatron.something.else.should == 4
        configatron.and.another.thing.should == 42
      end
      
    end
    
  end
  
end

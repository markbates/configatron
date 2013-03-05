require File.dirname(__FILE__) + '/../spec_helper'

describe Configatron::Rack do
  %w{development test production cucumber}.each do |env|
    describe env do
      let(:root) { File.join(File.dirname(__FILE__), '..', "tmp_rack_app_root_#{env}") }
      let(:configatron_path) { File.join(root, 'config', 'configatron') }
      let(:defaults_file_loc) { File.join(configatron_path, 'defaults.rb') }
      let(:env_file_loc) { File.join(configatron_path, "#{env}.rb") }
      let(:env_folder_loc) { File.join(configatron_path, env) }
      let(:env_bar_loc) { File.join(env_folder_loc, 'bar.rb') }
      let(:env_foo_loc) { File.join(env_folder_loc, 'foo.rb') }

      before(:each) do
        ENV['RACK_ENV'] = env
        if File.exists?(root)
          FileUtils.rm_rf(root)
        end

        FileUtils.mkdir_p(env_folder_loc)

        File.open(defaults_file_loc, 'w') do |f|
          f.puts 'configatron.fooa = :foo'
          f.puts 'configatron.bara = :bar'
          f.puts 'configatron.env = :default'
          f.puts 'configatron.something.else = 1'
          f.puts 'configatron.and.another.thing = 42'
        end

        File.open(env_file_loc, 'w') do |f|
          f.puts "configatron.env = :#{env}"
          f.puts 'configatron.something.else = 2'
        end

        File.open(env_bar_loc, 'w') do |f|
          f.puts "configatron.bara = 'BAR!!'"
          f.puts 'configatron.something.else = 3'
        end

        File.open(env_foo_loc, 'w') do |f|
          f.puts "configatron.fooa = :fubar"
          f.puts 'configatron.something.else = 4'
        end

        FileUtils.cd(root)
      end

      after(:each) do
        FileUtils.rm_rf(root)
      end

      it 'should read the defaults first and then the env file' do
        Configatron::Rack.init
        configatron.fooa.should == :fubar
        configatron.bara.should == 'BAR!!'
        configatron.env.should == env.to_sym
        configatron.something.else.should == 4
        configatron.and.another.thing.should == 42
      end
    end
  end
end

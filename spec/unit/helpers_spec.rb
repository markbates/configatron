require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Configatron::Helpers do
  
  before :each do
    configatron.reset!
  end
  
  describe "exists?" do
    
    it "should return true or false if the configuration parameter exists" do
      
      configatron.exists?(:foo).should == false
      configatron.exists?(:email).should == false
      
      configatron do |config|
        config.foo = :bar
        config.namespace(:email) do |email|
          email.address = "mark@mackframework.com"
        end
      end
      
      configatron.exists?(:foo).should == true
      configatron.exists?(:email).should == true
      configatron.email.exists?(:address).should == true
      configatron.email.exists?(:server).should == false
      
    end
    
  end
  
  describe "retrieve" do
    
    before :each do
      configatron do |config|
        config.foo = :bar
        config.namespace(:email) do |email|
          email.address = "mark@mackframework.com"
        end
      end      
    end
    
    it "should return a valid parameter" do
      configatron.retrieve(:foo).should == :bar
      configatron.email.retrieve(:address).should == "mark@mackframework.com"
    end
    
    it "should return a default value if one is specified" do
      configatron.retrieve(:name, "mark").should == "mark"
      configatron.email.retrieve(:server, "pop3.example.com").should == "pop3.example.com"
    end
    
    it "should behave like a standard missing parameter if no default value is specified" do
      lambda{configatron.retrieve(:name)}.should raise_error(NoMethodError)
      lambda{configatron.email.retrieve(:name)}.should raise_error(NoMethodError)
    end
    
    it "should return nil if the default value is nil" do
      configatron.retrieve(:name, nil).should == nil
    end
    
    it "should work!" do
      require 'logger'
      configatron do |config|
        config.namespace(:mack) do |mack|
          mack.render_url_timeout = 5
          mack.cache_classes = true
          mack.use_lint = true
          mack.show_exceptions = true
          mack.session_id = "_mack_session_id"
          mack.cookie_values = {
            "path" => "/"
          }
          mack.site_domain = "http://localhost:3000"
          mack.use_distributed_routes = false
          mack.distributed_app_name = nil
          mack.drb_timeout = 1
          mack.default_respository_name = "default"
        end
        config.namespace(:cachetastic_default_options) do |cache|
          cache.debug = false
          cache.adapter = :local_memory
          logger = ::Logger.new(STDOUT)
          logger.level = ::Logger::INFO
          cache.logger = logger
        end
        config.namespace(:log) do |log|
          log.detailed_requests = true
          log.level = :info
          log.console = false
          log.file = true
          log.console_format = "%l:\t[%d]\t%M"
          log.file_format = "%l:\t[%d]\t%M"
        end
      end
      configatron do |config|
        config.namespace(:mack) do |mack|
          mack.drb_timeout = 0
          mack.cookie_values = {}
        end
        config.namespace(:log) do |log|
          log.level = :error
        end
        config.run_remote_tests = true
      end
      
      configatron.log.retrieve(:file, false).should == true
      configatron.log.file.should == true

    end
    
  end
  
end
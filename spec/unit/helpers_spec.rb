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
    
  end
  
end
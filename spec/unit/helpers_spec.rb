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
  
end
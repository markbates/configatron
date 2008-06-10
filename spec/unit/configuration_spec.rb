require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "The configatron method" do
  
  before :each do
    configatron.reset!
  end
  
  describe "namespace" do
    
    it "should let you 'namespace' a set of configuration parameters" do
      lambda{configatron.foo}.should raise_error(NoMethodError)
      configatron do |config|
        config.namespace(:foo) do |foo|
          foo.bar = :bar
        end
      end
      configatron.foo.bar.should == :bar
    end
    
    it "should raise NoMethodError if nil_for_missing is set to false" do
      lambda{configatron.foo}.should raise_error(NoMethodError)
      configatron do |config|
        config.namespace(:foo) do |foo|
          foo.bar = :bar
        end
      end
      lambda{configatron.foo.say_hello}.should raise_error(NoMethodError)
    end
    
    it "should allow for unlimited nested namespaces" do
      configatron do |config|
        config.namespace(:foo) do |foo|
          foo.bar = :bar
          foo.namespace(:apples) do |apps|
            apps.granny_smith = "Granny Smith"
            apps.red = "Red"
          end
        end
      end
      configatron.foo.bar.should == :bar
      configatron.foo.apples.granny_smith.should == "Granny Smith"
    end
    
  end
  
end

describe Configatron::Configuration do
  
  before :each do
    configatron.reset!
  end
  
  it "should be a Singleton" do
    lambda{Configatron::Configuration.new}.should raise_error(NoMethodError)
    Configatron::Configuration.instance.should == Configatron::Configuration.instance
  end
  
  it "reset should remove all added methods" do
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
    
    configatron.nil_for_missing.should == false
    
    configatron do |config|
      config.rst1 = "RST1"
      config.rst2 = "RST2"
    end
    
    configatron.should respond_to(:rst1)
    configatron.should respond_to(:rst2)
    
    configatron.nil_for_missing = true
    configatron.nil_for_missing.should == true
    
    configatron.reset
    
    configatron.nil_for_missing.should == true
    
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
    
  end
  
  it "reset! should remove all added methods and revert the nil_for_missing setting" do
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
    
    configatron.nil_for_missing.should == false
    
    configatron do |config|
      config.rst1 = "RST1"
      config.rst2 = "RST2"
    end
    
    configatron.should respond_to(:rst1)
    configatron.should respond_to(:rst2)
    
    configatron.nil_for_missing = true
    configatron.nil_for_missing.should == true
    
    configatron.reset!
    
    configatron.nil_for_missing.should == false
    
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
  end
  
end
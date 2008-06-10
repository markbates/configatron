require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "The configatron method" do
  
  before :each do
    configatron.reset!
  end
  
  it "should raise NoMethodError if the parameter doesn't exist" do
    lambda{configatron.i_dont_exist}.should raise_error(NoMethodError)
  end
  
  it "should return nil if nil_for_missing is set to true" do
    configatron.nil_for_missing = true
    configatron.i_dont_exist.should == nil
  end
  
  it "should take a block that allows for the configuration of the configatron system" do
    lambda{configatron.foo}.should raise_error(NoMethodError)
    configatron do |config|
      config.foo = :bar
      config.say_hello = "Hello World"
    end
    configatron.foo.should == :bar
    configatron.say_hello == "Hello World"
  end
  
  it "should allow previously defined parameters to be redefined" do
    configatron do |config|
      config.foo = :bar
    end
    configatron.foo.should == :bar
    configatron do |config|
      config.foo = "fubar"
    end
    configatron.foo.should == "fubar"
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

describe Configatron do
  
  it "should be a Singleton" do
    lambda{Configatron::Configuration.new}.should raise_error(NoMethodError)
    Configatron::Configuration.instance.should == Configatron::Configuration.instance
  end
  
  it "reset! should remove all added methods" do
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
    
    configatron do |config|
      config.rst1 = "RST1"
      config.rst2 = "RST2"
    end
    
    configatron.should respond_to(:rst1)
    configatron.should respond_to(:rst2)
    
    configatron.reset!
    
    configatron.should_not respond_to(:rst1)
    configatron.should_not respond_to(:rst2)
    
  end
  
end
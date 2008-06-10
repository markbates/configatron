require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Kernel do

  it "should have a configatron method" do
    configatron
  end
  
  describe "configatron" do
    
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
    
  end
  
end
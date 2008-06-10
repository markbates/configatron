require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "The configuration method" do
  
  it "should be available in the Kernel" do
    configatron
  end
  
  it "should return a parameter using the parameter name as a method call"
  
  it "should return nil using the parameter name as a method call if the parameter doesn't exist"
  
  it "should take a block that allows for the configuration of the configatron system"
  
end

describe Configatron do
  
  it "should be a Singleton" do
    lambda{Configatron.new}.should raise_error(NoMethodError)
    Configatron.instance.should == Configatron.instance
  end
  
end
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "In Kernel" do
  
  it "there should be a configatron method" do
    configatron
  end
  
end

describe Configatron do
  
  it "should be a Singleton" do
    lambda {Configatron.new}.should raise_error(NoMethodError)
    Configatron.instance.should equal Configatron.instance
  end
  
end
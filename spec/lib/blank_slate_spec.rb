require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Configatron::BlankSlate do

  before(:each) do
    configatron.reset!
  end
  
  it "should respond to __id__, __send__, and instance_eval" do
    lambda {
      Configatron::BlankSlate.new.__id__
      Configatron::BlankSlate.new.__send__
      Configatron::BlankSlate.new.__methods__
      Configatron::BlankSlate.new.instance_eval { 'hi' }
    }.should_not raise_error(NoMethodError)
  end
  
  it "has methods" do
    Configatron::BlankSlate.new.methods.should == ["methods", "__id__", "__send__", "instance_eval", "configatron", "send_with_chain"]
  end
  
  it "should not respond to Object's immediate methods" do
    object_methods = Object.methods(false).reject { |m| m =~ /^(__|instance_eval)/ }.sort
    object_methods.each do |meth|
      lambda {
        Configatron::BlankSlate.new.__send__(meth)
      }.should raise_error(NoMethodError)
    end
  end

end
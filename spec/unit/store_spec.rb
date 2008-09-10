require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Configatron::Store do
  
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
    
    it "should not override all parameters when you namespace" do
      configatron do |config|
        config.namespace(:foo) do |foo|
          foo.bar = :bar
          foo.name = "mark"
        end
      end
      configatron.foo.bar.should == :bar
      configatron.foo.name.should == "mark"
      
      configatron do |config|
        config.namespace(:foo) do |foo|
          foo.name = "mark bates"
        end
      end
      
      configatron.foo.bar.should == :bar
      configatron.foo.name.should == "mark bates"
    end
  end
  
  describe 'to_hash' do
    it "should convert the store to a hash" do
      configatron do |config|
        config.namespace :baz do |baz|
          baz.foo = 'bar'
        end
      end
      
      configatron.baz.to_hash.should == {:foo => 'bar'}
    end
    
    it 'should support multiple nesting levels in the store' do
      configatron do |config|
        config.namespace :baz do |baz|
          baz.foo = 'bar'
          baz.namespace :quux do |quux|
            quux.foob = 'barbaz'
          end
        end
      end
      
      configatron.baz.to_hash.should == {:foo => 'bar', :quux => {:foob => 'barbaz'}}
    end
  end
end

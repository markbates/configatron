require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Configatron::Configuration do
  
  before :each do
    configatron.reset!
  end
  
  it "should be a Singleton" do
    lambda{Configatron::Configuration.new}.should raise_error(NoMethodError)
    Configatron::Configuration.instance.should == Configatron::Configuration.instance
  end
  
  describe "configure_from_hash" do
    
    it "should take a Hash with the same outcome as the configure method" do
      configatron.should_not respond_to(:bart)
      configatron.should_not respond_to(:homer)
      
      configatron.configure_from_hash(:bart => "Bart Simpson", "homer" => "Homer Simpson")
      
      configatron.should respond_to(:bart)
      configatron.should respond_to(:homer)
      
      configatron.bart.should == "Bart Simpson"
      configatron.homer.should == "Homer Simpson"
    end
    
  end
  
  describe "configure_from_yaml" do
    
    it "should take a path to YAML file and use it configure configatron" do
      configatron.should_not respond_to(:family_guy)
      configatron.should_not respond_to(:lois)
      
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'family_guy.yml'))
      
      configatron.should respond_to(:family_guy)
      configatron.should respond_to(:lois)
      
      configatron.family_guy.should == "Peter Griffin"
      configatron.lois.should == "Lois Griffin"
    end
    
    it "should silently file if the file doesn't exist" do
      lambda {configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'i_dont_exist.yml'))}.should_not raise_error(Errno::ENOENT)
    end
    
  end
  
  describe "revert" do
    
    it "should roll back 1 level by default" do
      configatron.should_not respond_to(:bart)
      configatron.should_not respond_to(:homer)
      
      configatron do |config|
        config.bart = "Bart Simpson"
      end
      configatron do |config|
        config.homer = "Homer Simpson"
      end
      
      configatron.should respond_to(:bart)
      configatron.should respond_to(:homer)
      
      configatron.bart.should == "Bart Simpson"
      configatron.homer.should == "Homer Simpson"
      
      configatron.revert
      
      configatron.should respond_to(:bart)
      configatron.should_not respond_to(:homer)
      configatron.bart.should == "Bart Simpson"
      lambda{configatron.homer}.should raise_error(NoMethodError)
    end
    
    it "should roll back n levels if specified" do
      configatron.should_not respond_to(:bart)
      configatron.should_not respond_to(:homer)
      
      configatron do |config|
        config.bart = "Bart Simpson"
      end
      configatron do |config|
        config.homer = "Homer Simpson"
      end
      
      configatron.should respond_to(:bart)
      configatron.should respond_to(:homer)
      
      configatron.bart.should == "Bart Simpson"
      configatron.homer.should == "Homer Simpson"
      
      configatron.revert(2)
      
      configatron.should_not respond_to(:bart)
      configatron.should_not respond_to(:homer)
      lambda{configatron.bart}.should raise_error(NoMethodError)
      lambda{configatron.homer}.should raise_error(NoMethodError)
    end
    
  end
  
  describe "reset" do
  
    it "should remove all added methods" do
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
    
  end
  
  describe "reset!" do

    it "should remove all added methods and revert the nil_for_missing setting" do
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
  
end
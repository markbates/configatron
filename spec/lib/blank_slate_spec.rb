require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ConfigatronBlankSlate do

  before(:each) do
    configatron.reset!
  end
  
  it "should respond to __id__ and __send__ built in methods" do
    lambda {
      ConfigatronBlankSlate.new.__id__
      ConfigatronBlankSlate.new.__send__
    }.should_not raise_error(NoMethodError)
  end
  
  it "should have methods on the CONFIGATRON_WHITELIST" do
    blank_slate = ConfigatronBlankSlate.new
    ConfigatronBlankSlate::CONFIGATRON_WHITELIST.each do |meth|
      lambda {
        blank_slate__send__
      }.should_not raise_error(NoMethodError)
    end
  end
  
end
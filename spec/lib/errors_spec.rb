require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "errors" do
  
  it "should have descriptive message" do
    Configatron::ProtectedParameter.new("name").message.should == "Can not modify protected parameter: 'name'"
  end
  
end
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Kernel do

  it "should have a configatron method" do
    configatron
  end
  
end
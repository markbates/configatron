require File.dirname(__FILE__) + '/../spec_helper'

describe Configatron::Delayed do
  
  before(:each) do
    configatron.temp_start
  end
  
  after(:each) do
    configatron.temp_end
  end
  
  it 'should execute the code once at a later date' do
    configatron.tv.shows = ['seinfeld', 'simpsons']
    configatron.my.tv.shows = Configatron::Delayed.new do
      "My shows are: #{configatron.tv.shows.join(', ')}"
    end
    configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage']
    configatron.my.tv.shows.should == 'My shows are: seinfeld, simpsons, entourage'
    configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage', 'office']
    configatron.my.tv.shows.should == 'My shows are: seinfeld, simpsons, entourage'
  end
  
end

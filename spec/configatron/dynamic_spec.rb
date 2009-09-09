require File.dirname(__FILE__) + '/../spec_helper'

describe Configatron::Dynamic do

  before(:each) do
    configatron.temp_start
  end
  
  after(:each) do
    configatron.temp_end
  end
  
  it 'should execute the code at a later date' do
    configatron.tv.shows = ['seinfeld', 'simpsons']
    configatron.my.tv.shows = Configatron::Dynamic.new do
      "My shows are: #{configatron.tv.shows.join(', ')}"
    end
    configatron.my.tv.shows.should == 'My shows are: seinfeld, simpsons'
    configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage']
    configatron.my.tv.shows.should == 'My shows are: seinfeld, simpsons, entourage'
    configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage', 'office']
    configatron.my.tv.shows.should == 'My shows are: seinfeld, simpsons, entourage, office'
  end
  
end

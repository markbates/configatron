require File.dirname(__FILE__) + '/../spec_helper'

describe Configatron::Proc do

  before(:each) do
    configatron.temp_start
  end

  after(:each) do
    configatron.temp_end
  end
  
  describe Configatron::Dynamic do

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
    
    it 'should work with retrieve' do
      configatron.tv.shows = ['seinfeld', 'simpsons']
      configatron.my.tv.shows = Configatron::Dynamic.new do
        "My shows are: #{configatron.tv.shows.join(', ')}"
      end
      configatron.my.tv.retrieve(:shows).should == 'My shows are: seinfeld, simpsons'
      configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage']
      configatron.my.tv.retrieve(:shows).should == 'My shows are: seinfeld, simpsons, entourage'
      configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage', 'office']
      configatron.my.tv.retrieve(:shows).should == 'My shows are: seinfeld, simpsons, entourage, office'
    end

  end
  
  describe Configatron::Delayed do

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
    
    it 'should work with retrieve' do
      configatron.tv.shows = ['seinfeld', 'simpsons']
      configatron.my.tv.shows = Configatron::Delayed.new do
        "My shows are: #{configatron.tv.shows.join(', ')}"
      end
      configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage']
      configatron.my.tv.retrieve(:shows).should == 'My shows are: seinfeld, simpsons, entourage'
      configatron.tv.shows = ['seinfeld', 'simpsons', 'entourage', 'office']
      configatron.my.tv.retrieve(:shows).should == 'My shows are: seinfeld, simpsons, entourage'
    end

  end
  
end

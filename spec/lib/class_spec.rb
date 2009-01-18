require File.join(File.dirname(__FILE__), '..', 'spec_helper')

configatron.foo.bar = :bar
configatron.a.b.c.d = 'D'

class Foo
end

module A
  module B
    class C
    end
  end
end

describe Class do
  
  describe 'to_configatron' do
    
    it 'should return a Configatron::Store object based on the name of the class' do
      Foo.to_configatron.should be_kind_of(Configatron::Store)
      Foo.to_configatron.bar.should == :bar
      A::B::C.to_configatron.d.should == 'D'
    end
    
  end
  
end
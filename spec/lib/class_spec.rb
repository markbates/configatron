require File.join(File.dirname(__FILE__), '..', 'spec_helper')

configatron.foo.bar = :bar
configatron.a.b.c.d = 'D'

configatron.cachetastic.foo.bar = 'cachetastic-fubar'
configatron.l.m.n.o.p = 'P'

class Foo
end

module A
  module B
    class C
    end
  end
end

module N
  class O
  end
end

describe Class do
  
  describe 'to_configatron' do
    
    it 'should return a Configatron::Store object based on the name of the class' do
      Foo.to_configatron.should be_kind_of(Configatron::Store)
      Foo.to_configatron.bar.should == :bar
      A::B::C.to_configatron.d.should == 'D'
    end
    
    it 'should take an array to prepend to the object' do
      Foo.to_configatron(:cachetastic).bar.should == 'cachetastic-fubar'
      N::O.to_configatron(:l, 'm').p.should == 'P'
    end
    
    it 'should convert a string to a Store object' do
      'A::B::C'.to_configatron.d.should == configatron.a.b.c.d
    end
    
  end
  
end
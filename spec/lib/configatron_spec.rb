require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "configatron" do

  before(:each) do
    configatron.reset!
  end

  it 'should respond to test without blowing up' do
    configatron.test.should be_nil
    configatron.test = 'hi!'
    configatron.test.should == 'hi!'
    configatron.foo.test.should be_nil
    configatron.foo.test = 'hi!'
    configatron.foo.test.should == 'hi!'
  end
  
  describe "respond_to" do
    
    it 'should respond_to respond_to?' do
      configatron.test.should be_nil
      configatron.test = 'hi!'
      configatron.respond_to?(:test).should be_true
      configatron.respond_to?(:plop).should be_false
    end

    it 'should respond_to respond_to? recursively' do
      configatron.foo.test.should be_nil
      configatron.foo.test = 'hi!l'
      configatron.foo.respond_to?(:test).should be_true
      configatron.foo.respond_to?(:plop).should be_false
    end
    
  end
  
  describe 'block assignment' do
    
    it 'should pass the store to the block' do
      configatron.test do |c|
        c.should === configatron.test
      end
    end

    it 'should persist changes outside of the block' do
      configatron.test.one = 1
      configatron.test.two = 2
      configatron.test do |c|
        c.two = 'two'
      end
      configatron.test.one.should === 1
      configatron.test.two.should === 'two'
    end

    it 'should pass the default store to a temp block' do
      configatron.temp do |c|
        c.class.should == Configatron::Store
      end
    end

  end

  describe 'exists?' do

    it 'should return true or false depending on whether or the setting exists' do
      configatron.temp do
        configatron.i.am.alive = 'alive!'
        configatron.i.am.should be_exists(:alive)
        configatron.i.am.should be_exists('alive')
      end
      configatron.i.am.should_not be_exists(:alive)
      configatron.i.am.should_not be_exists('alive')
    end

  end

  describe 'configatron_keys' do

    it 'should return a list of keys in the store' do
      configatron.abcd.a = 'A'
      configatron.abcd.b = 'B'
      configatron.abcd.c = 'C'
      configatron.abcd.configatron_keys.should == ['a', 'b', 'c']
    end

  end

  describe 'heirarchy' do

    it 'should return a string representing where in the heirarchy the current Store is' do
      configatron.a.b.c.d.heirarchy.should == 'a.b.c.d'
    end

  end

  describe 'protect' do

    it 'should protect a parameter and prevent it from being set' do
      configatron.one = 1
      configatron.protect(:one)
      lambda{configatron.one = 'one'}.should raise_error(Configatron::ProtectedParameter)
      configatron.one.should == 1
    end

    it 'should protect basic methods' do
      lambda{configatron.object_id = 123456}.should raise_error(Configatron::ProtectedParameter)
      lambda{configatron.foo.object_id = 123456}.should raise_error(Configatron::ProtectedParameter)
    end

    it 'should work with nested parameters' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.letters.protect(:a)
      lambda{configatron.letters.a = 'a'}.should raise_error(Configatron::ProtectedParameter)
      configatron.letters.a.should == 'A'
      configatron.protect(:letters)
      lambda{configatron.letters.a = 'a'}.should raise_error(Configatron::ProtectedParameter)
      lambda{configatron.letters = 'letter'}.should raise_error(Configatron::ProtectedParameter)
    end

    it 'should work with configure_from_hash' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.letters.protect(:a)
      lambda{configatron.configure_from_hash(:letters => {:a => 'a'})}.should raise_error(Configatron::ProtectedParameter)
      configatron.letters.a.should == 'A'
      configatron.protect(:letters)
      lambda{configatron.letters.configure_from_hash(:a => 'a')}.should raise_error(Configatron::ProtectedParameter)
      lambda{configatron.configure_from_hash(:letters => 'letters')}.should raise_error(Configatron::ProtectedParameter)
    end

    it "should be able to protect all parameters at once" do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.protect_all!
      [:a,:b].each do |l|
        lambda{configatron.configure_from_hash(:letters => {l => l.to_s})}.should raise_error(Configatron::ProtectedParameter)
        configatron.letters.send(l).should == l.to_s.upcase
      end
      lambda{configatron.letters.configure_from_hash(:a => 'a')}.should raise_error(Configatron::ProtectedParameter)
      lambda{configatron.configure_from_hash(:letters => 'letters')}.should raise_error(Configatron::ProtectedParameter)
    end

    it "should be able to unprotect a parameter" do
      configatron.one = 1
      configatron.protect(:one)
      configatron.unprotect(:one)
      lambda{configatron.one = 2}.should_not raise_error
    end

    it "should be able to unprotect all parameters at once" do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.protect_all!
      configatron.unprotect_all!
      lambda{configatron.one = 2}.should_not raise_error
      lambda{configatron.letters.configure_from_hash(:a => 'a')}.should_not raise_error
    end

  end

  describe 'lock' do
    
    before :each do
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.letters.greek.alpha = 'alpha'
      configatron.lock(:letters)
    end

    it 'should allow setting of existing parameters in locked parameter' do
      lambda { configatron.letters.a = 'a' }.should_not raise_error
    end

    it 'should not allow setting of a parameter that is not already set' do
      lambda { configatron.letters.c = 'C' }.should raise_error(Configatron::LockedNamespace)
    end

    it 'should allow setting of existing parameters in child of locked parameter' do
      lambda { configatron.letters.greek.alpha = 'a' }.should_not raise_error
    end

    it 'should not allow setting of new parameters in child of locked parameter' do
      lambda { configatron.letters.greek.beta = 'beta' }.should raise_error(Configatron::LockedNamespace)
    end

    it 'should not affect parameters below the locked namespace' do
      lambda { configatron.one = 1 }.should_not raise_error
    end

    it 'should raise an ArgumentError if unknown namespace is locked' do
      lambda { configatron.lock(:numbers).should raise_error(ArgumentError) }
    end

    describe 'then unlock' do
      
      before :each do
        configatron.unlock(:letters)
      end

      it 'should allow setting of new parameter in unlocked namespace' do
        lambda { configatron.letters.d = 'd' }.should_not raise_error
      end

      it 'should allow setting of new parameter in unlocked namespace\'s child' do
        lambda { configatron.letters.greek.zeta = 'z' }.should_not raise_error
      end

      it 'should raise an ArgumentError if unknown namespace is unlocked' do
        lambda { configatron.unlock(:numbers).should raise_error(ArgumentError) }
      end
      
    end
    
  end

  describe 'temp' do

    it 'should revert back to the original parameters when the block ends' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.temp do
        configatron.letters.b = 'bb'
        configatron.letters.c = 'c'
        configatron.one.should == 1
        configatron.letters.a.should == 'A'
        configatron.letters.b.should == 'bb'
        configatron.letters.c.should == 'c'
      end
      configatron.one.should == 1
      configatron.letters.a.should == 'A'
      configatron.letters.b.should == 'B'
      configatron.letters.c.should be_nil
    end

    it 'should take an optional hash of parameters' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.temp(:letters => {:b => 'bb', :c => 'c'}) do
        configatron.one.should == 1
        configatron.letters.a.should == 'A'
        configatron.letters.b.should == 'bb'
        configatron.letters.c.should == 'c'
      end
      configatron.one.should == 1
      configatron.letters.a.should == 'A'
      configatron.letters.b.should == 'B'
      configatron.letters.c.should be_nil
    end

    it 'should work the same as temp_start/temp_end' do
      configatron.one = 1
      configatron.temp_start
      configatron.one = 'ONE'
      configatron.one.should == 'ONE'
      configatron.temp_end
      configatron.one.should == 1
    end

    it 'should be able to nest' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.temp do
        configatron.letters.b = 'bb'
        configatron.letters.c = 'c'
        configatron.one.should == 1
        configatron.letters.a.should == 'A'
        configatron.letters.b.should == 'bb'
        configatron.letters.c.should == 'c'
        configatron.temp do
          configatron.letters.b = 'bbb'
          configatron.one.should == 1
          configatron.letters.a.should == 'A'
          configatron.letters.b.should == 'bbb'
          configatron.letters.c.should == 'c'
        end
      end
      configatron.one.should == 1
      configatron.letters.a.should == 'A'
      configatron.letters.b.should == 'B'
      configatron.letters.c.should be_nil
    end

  end

  describe 'configure_from_hash' do

    it 'should configure itself from a hash' do
      configatron.foo.should be_nil
      configatron.configure_from_hash(:foo => :bar)
      configatron.foo.should == :bar
    end

    it 'should handled deeply nested params' do
      configatron.friends.rachel.should be_nil
      configatron.configure_from_hash(:friends => {:rachel => 'Rachel Green'})
      configatron.friends.rachel.should == 'Rachel Green'
    end

    it 'should not remove previously defined params' do
      configatron.friends.rachel = 'Rachel Green'
      configatron.friends.ross = 'Ross Gellar'
      configatron.friends.monica = 'Monica Gellar'
      configatron.configure_from_hash(:friends => {:rachel => 'R. Green', :monica => 'Monica Bing'})
      configatron.friends.ross.should == 'Ross Gellar'
      configatron.friends.rachel.should == 'R. Green'
      configatron.friends.monica.should == 'Monica Bing'
    end

  end

  describe 'configure_from_yaml' do

    it 'should configure itself from a yaml file' do
      configatron.futurama.should be_nil
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'futurama.yml'))
      configatron.futurama.robots.bender.should == 'Bender The Robot'
    end

    it 'should not remove previously defined params' do
      configatron.futurama.mutants.leela = 'Leela'
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'futurama.yml'))
      configatron.futurama.robots.bender.should == 'Bender The Robot'
      configatron.futurama.mutants.leela = 'Leela'
    end

    it "should fail silently if the file doesn't exist" do
      lambda{configatron.configure_from_yaml('i_dont_exist.yml')}.should_not raise_error
    end

    it "should be able to load a specific hash from the file" do
      configatron.others.should be_nil
      configatron.survivors.should be_nil
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'lost.yml'), :hash => "survivors")
      configatron.others.should be_nil
      configatron.survivors.should be_nil
      configatron.on_island.jack.should == 'Jack Shepherd'
    end

    it 'should run the yaml through ERB' do
      configatron.math.should be_nil
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'math.yml'))
      configatron.math.should_not be_nil
      configatron.math.four.should == 4
    end

    it 'should handle merged keys' do
      unless RUBY_VERSION.match(/^2\.0/)
        configatron.food.should be_nil
        configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'merge.yml'))
        configatron.food.should_not be_nil
        configatron.food.list.should == [:apple, :banana, :tomato, :brocolli, :spinach]
      end
    end
    
    it "should handle complex yaml" do
      configatron.complex_development.bucket.should be_nil
      configatron.configure_from_yaml(File.join(File.dirname(__FILE__), 'complex.yml'))
      configatron.complex_development.bucket.should == 'develop'
      configatron.complex_development.access_key_id.should == 'access_key'
    end
    
  end

  it 'should return a parameter' do
    configatron.foo = :bar
    configatron.foo.should == :bar
  end

  it 'should return a nested parameter' do
    configatron.children.dylan = 'Dylan Bates'
    configatron.children.dylan.should == 'Dylan Bates'
  end

  it 'should set a nested parameter and not remove previously defined params' do
    configatron.friends.rachel = 'Rachel Green'
    configatron.friends.rachel.should == 'Rachel Green'
    configatron.friends.ross = 'Ross Gellar'
    configatron.friends.ross.should == 'Ross Gellar'
    configatron.friends.monica = 'Monica Gellar'
    configatron.friends.monica.should == 'Monica Gellar'
    configatron.friends.rachel = 'R. Green'
    configatron.friends.monica = 'Monica Bing'
    configatron.friends.rachel.should == 'R. Green'
    configatron.friends.ross.should == 'Ross Gellar'
    configatron.friends.monica.should == 'Monica Bing'
  end

  it 'should return the Configatron instance' do
    configatron.should be_is_a(Configatron)
  end

  describe 'to_hash' do

    it 'should return a hash of all the params' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'

      h = configatron.to_hash
      h.should be_an_instance_of(Hash)
      h[:letters].should be_an_instance_of(Hash)

      h[:one].should == 1
      h[:letters][:b].should == 'B'
    end

  end

  describe 'inspect' do

    it 'should call return the inspect method of the to_hash method' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.numbers.small.one = 1
      configatron.numbers.small.others = [2,3]
      configatron.numbers.big.one.hundred = '100'

      configatron.inspect.should == %{
configatron.letters.a = "A"
configatron.letters.b = "B"
configatron.numbers.big.one.hundred = "100"
configatron.numbers.small.one = 1
configatron.numbers.small.others = [2, 3]
configatron.one = 1
}.strip

    end

  end

  describe 'nil?' do

    it 'should return true if there are no parameters' do
      configatron.should be_nil
      configatron.friends.should be_nil
    end

    it 'should return true if there are no parameters on a nested parameter' do
      configatron.friends.monica.should be_nil
    end

  end

  describe 'retrieve' do

    it 'should retrieve a parameter' do
      configatron.office = 'Michael'
      configatron.retrieve(:office).should == 'Michael'
    end

    it 'should return the optional second parameter if the config setting is nil' do
      configatron.retrieve(:office, 'Stanley').should == 'Stanley'
    end

    it 'should work with a symbol or a string' do
      configatron.office = 'Michael'
      configatron.retrieve(:office).should == 'Michael'
      configatron.retrieve('office').should == 'Michael'
    end

    it 'should work on nested parameters' do
      configatron.the.office = 'Michael'
      configatron.the.retrieve(:office).should == 'Michael'
      configatron.the.retrieve('office').should == 'Michael'
    end

  end

  describe 'remove' do

    it 'should remove a parameter' do
      configatron.movies = 'Pulp Fiction'
      configatron.movies.should == 'Pulp Fiction'
      configatron.remove(:movies)
      configatron.movies.should be_nil
    end

    it 'should remove a nested parameter' do
      configatron.the.movies = 'Pulp Fiction'
      configatron.the.movies.should == 'Pulp Fiction'
      configatron.the.remove(:movies)
      configatron.the.movies.should be_nil
    end

    it 'should work with a symbol or a string' do
      configatron.the.movies = 'Pulp Fiction'
      configatron.the.office = 'Michael'
      configatron.the.remove(:movies)
      configatron.the.movies.should be_nil
      configatron.the.remove('office')
      configatron.the.office.should be_nil
    end

    it 'should remove all sub-parameters' do
      configatron.the.movies = 'Pulp Fiction'
      configatron.the.office = 'Michael'
      configatron.remove(:the)
      configatron.the.should be_nil
      configatron.the.movies.should be_nil
    end

  end

  describe 'set_default' do

    it 'should set a default parameter value' do
      configatron.set_default(:movies, 'Pulp Fiction')
      configatron.movies.should == 'Pulp Fiction'
    end

    it 'should set a default parameter value for a nested parameter' do
      configatron.the.set_default(:movies, 'Pulp Fiction')
      configatron.the.movies.should == 'Pulp Fiction'
    end

    it 'should not set the parameter if it is already set' do
      configatron.movies = 'Transformers'
      configatron.set_default(:movies, 'Pulp Fiction')
      configatron.movies.should == 'Transformers'
    end

    it 'should not set the nested parameter if it is already set' do
      configatron.the.movies = 'Transformers'
      configatron.the.set_default(:movies, 'Pulp Fiction')
      configatron.the.movies.should == 'Transformers'
    end

  end

  describe 'reset!' do

    it 'should clear out all parameter' do
      configatron.one = 1
      configatron.letters.a = 'A'
      configatron.letters.b = 'B'
      configatron.one.should == 1
      configatron.letters.a.should == 'A'
      configatron.reset!
      configatron.one.should be_nil
      configatron.letters.a.should be_nil
    end

  end

  describe :blank? do

    context "uninitialized option" do
      specify { configatron.foo.bar.should be_blank }
    end

    context "nil option" do
      before { configatron.foo.bar = nil }
      specify { configatron.foo.bar.should be_blank }
    end

    context "false option" do
      before { configatron.foo.bar = false }
      specify { configatron.foo.bar.should be_blank }
    end

    context "empty string option" do
      before { configatron.foo.bar = "" }
      specify { configatron.foo.bar.should be_blank }
    end

    context "empty hash option" do
      before { configatron.foo.bar = {} }
      specify { configatron.foo.bar.should be_blank }
    end

    context "empty array option" do
      before { configatron.foo.bar = [] }
      specify { configatron.foo.bar.should be_blank }
    end

    context "defined option" do
      before { configatron.foo.bar = 'asd' }
      subject { configatron.foo.bar }
      it { should_not be_blank }
      it { should == 'asd' }
    end
    
  end


  describe "boolean test" do

    context "nil option" do
      before { configatron.foo.bar = nil }
      specify { configatron.foo.bar?.should be_false }
    end

    context "false option" do
      before { configatron.foo.bar = false }
      specify { configatron.foo.bar?.should be_false }
    end

    context "string option" do
      before { configatron.foo.bar = 'asd' }
      specify { configatron.foo.bar?.should be_true }
    end

  end
  
end

require_relative '../_lib'

class Critic::Unit::KernelTest < Critic::Unit::Test
  before do
    @kernel = Configatron::KernelStore.new
  end

  describe 'delegation' do
    it 'passes on to Configatron::Store' do
      @kernel.a.b.c.d = 'D'
      @kernel.a.b.c.d.must_equal 'D'
    end
  end

  describe 'global configatron' do
    it 'returns an instance of Configatron::KernelStore' do
      configatron.kind_of?(Configatron::KernelStore).must_equal true
    end
  end

  describe "temp" do
    before do
      @kernel.a = 'A'
      @kernel.b = 'B'
    end

    it "allows for temporary setting of values" do
      @kernel.a.must_equal 'A'
      @kernel.b.must_equal 'B'
      @kernel.temp do
        @kernel.a = 'AA'
        @kernel.c = 'C'
        @kernel.a.must_equal 'AA'
        @kernel.b.must_equal 'B'
        @kernel.c.must_equal 'C'
      end
      @kernel.a.must_equal 'A'
      @kernel.b.must_equal 'B'
      @kernel.key?(:c).must_equal false
    end

    describe "start/end" do
      it "allows for temporary setting of values" do
        @kernel.a.must_equal 'A'
        @kernel.b.must_equal 'B'
        @kernel.temp_start
        @kernel.a = 'AA'
        @kernel.c = 'C'
        @kernel.a.must_equal 'AA'
        @kernel.b.must_equal 'B'
        @kernel.c.must_equal 'C'
        @kernel.temp_end
        @kernel.a.must_equal 'A'
        @kernel.b.must_equal 'B'
        @kernel.key?(:c).must_equal false
      end
    end
  end

  describe "temp" do
    before do
      @kernel.a = 'A'
      @kernel.b = 'B'
    end

    it "allows for temporary setting of values" do
      @kernel.a.must_equal 'A'
      @kernel.b.must_equal 'B'
      @kernel.temp do
        @kernel.a = 'AA'
        @kernel.c = 'C'
        @kernel.a.must_equal 'AA'
        @kernel.b.must_equal 'B'
        @kernel.c.must_equal 'C'
      end
      @kernel.a.must_equal 'A'
      @kernel.b.must_equal 'B'
      @kernel.key?(:c).must_equal false
    end

    describe "start/end" do
      it "allows for temporary setting of values" do
        @kernel.a.must_equal 'A'
        @kernel.b.must_equal 'B'
        @kernel.temp_start
        @kernel.a = 'AA'
        @kernel.c = 'C'
        @kernel.a.must_equal 'AA'
        @kernel.b.must_equal 'B'
        @kernel.c.must_equal 'C'
        @kernel.temp_end
        @kernel.a.must_equal 'A'
        @kernel.b.must_equal 'B'
        @kernel.key?(:c).must_equal false
      end
    end
  end

  describe "lock!" do
    before do
      @kernel.a.b.c.d = 'DD'
      @kernel.lock!
    end

    it "raises an error when accessing non-existing values" do
      @kernel.a.wont_be_nil
      @kernel.a.b.wont_be_nil
      @kernel.a.b.c.wont_be_nil
      @kernel.a.b.c.d.must_equal "DD"
      proc {@kernel.unknown}.must_raise(Configatron::UndefinedKeyError)
    end

    it "raises an error when trying to set a non-existing key" do
      proc {@kernel.unknown = "known"}.must_raise(Configatron::LockedError)
    end
  end
end

require_relative '../_lib'

class Critic::Unit::KernelTest < Critic::Unit::Test
  before do
    @kernel = Configatron::KernelStore.new
  end

  describe 'delegation' do
    it 'passes on to Configatron::Store' do
      @kernel.a.b.c.d = 'D'
      assert_equal('D', @kernel.a.b.c.d)
    end
  end

  describe 'global configatron' do
    it 'returns an instance of Configatron::KernelStore' do
      assert_equal(true, configatron.kind_of?(Configatron::KernelStore))
    end
  end

  describe "temp" do
    before do
      @kernel.a = 'A'
      @kernel.b = 'B'
    end

    it "allows for temporary setting of values" do
      assert_equal('A', @kernel.a)
      assert_equal('B', @kernel.b)
      @kernel.temp do
        @kernel.a = 'AA'
        @kernel.c = 'C'
        assert_equal('AA', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal('C', @kernel.c)
      end
      assert_equal('A', @kernel.a)
      assert_equal('B', @kernel.b)
      assert_equal(false, @kernel.key?(:c))
    end

    describe "start/end" do
      it "allows for temporary setting of values" do
        assert_equal('A', @kernel.a)
        assert_equal('B', @kernel.b)
        @kernel.temp_start
        @kernel.a = 'AA'
        @kernel.c = 'C'
        assert_equal('AA', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal('C', @kernel.c)
        @kernel.temp_end
        assert_equal('A', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal(false, @kernel.key?(:c))
      end
    end
  end

  describe "temp" do
    before do
      @kernel.a = 'A'
      @kernel.b = 'B'
    end

    it "allows for temporary setting of values" do
      assert_equal('A', @kernel.a)
      assert_equal('B', @kernel.b)
      @kernel.temp do
        @kernel.a = 'AA'
        @kernel.c = 'C'
        assert_equal('AA', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal('C', @kernel.c)
      end
      assert_equal('A', @kernel.a)
      assert_equal('B', @kernel.b)
      assert_equal(false, @kernel.key?(:c))
    end

    describe "start/end" do
      it "allows for temporary setting of values" do
        assert_equal('A', @kernel.a)
        assert_equal('B', @kernel.b)
        @kernel.temp_start
        @kernel.a = 'AA'
        @kernel.c = 'C'
        assert_equal('AA', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal('C', @kernel.c)
        @kernel.temp_end
        assert_equal('A', @kernel.a)
        assert_equal('B', @kernel.b)
        assert_equal(false, @kernel.key?(:c))
      end
    end
  end

  describe "lock!" do
    before do
      @kernel.a.b.c.d = 'DD'
      @kernel.lock!
    end

    it "raises an error when accessing non-existing values" do
      refute_nil(@kernel.a)
      refute_nil(@kernel.a.b)
      refute_nil(@kernel.a.b.c)
      assert_equal("DD", @kernel.a.b.c.d)
      assert_raises(Configatron::UndefinedKeyError) do
        @kernel.unknown
      end
    end

    it "raises an error when trying to set a non-existing key" do
      assert_raises(Configatron::LockedError) do
        @kernel.unknown = "known"
      end
    end
  end
end

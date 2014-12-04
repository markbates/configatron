require_relative '_lib'

class Critic::Functional::ConfigatronTest < Critic::Functional::Test
  before do
    @kernel = Configatron::RootStore.new
  end

  describe 'temp' do
    before do
      @kernel.a = 'A'
      @kernel.b = 'B'
    end

    it 'allows for temporary setting of values' do
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

    it 'nested' do
      @kernel.foo.bar = 'original'
      @kernel.temp do
        @kernel.foo.bar = 'temp'
        assert_equal('temp', @kernel.foo.bar)
      end
      assert_equal('original', @kernel.foo.bar)
    end

    it 'cleans up after an exception' do
      @kernel.foo.bar = 'original'

      assert_raises(RuntimeError) do
        @kernel.temp do
          @kernel.foo.bar = 'temp'
          raise RuntimeError.new('error')
        end
      end

      assert_equal('original', @kernel.foo.bar)
    end

    it 'restores locking state' do
      @kernel.lock!
      @kernel.temp do
        @kernel.unlock!
      end
      assert(@kernel.locked?)
    end

    describe 'start/end' do
      it 'allows for temporary setting of values' do
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

  describe 'lock!' do
    before do
      @kernel.a.b.c.d = 'DD'
      @kernel.lock!
    end

    it 'raises an error when accessing non-existing values' do
      assert @kernel.a != nil
      assert @kernel.a.b != nil
      assert @kernel.a.b.c != nil
      assert_equal('DD', @kernel.a.b.c.d)
      assert_raises(Configatron::UndefinedKeyError) do
        @kernel.unknown
      end
    end

    it 'responds to nil? for backward compatibility' do
      refute_nil @kernel.a
    end

    it 'raises an error when trying to set a non-existing key' do
      assert_raises(Configatron::LockedError) do
        @kernel.unknown = 'known'
      end
    end

    it 'locks during the block argument' do
      @kernel.unlock!

      @kernel.lock! do
        assert(@kernel.locked?)
      end

      assert(!@kernel.locked?)
    end

    it 'executes a block argument' do
      a = 1
      @kernel.lock! do
        a = 2
      end
      assert_equal(2, a)
    end
  end

  describe 'name' do
    it 'assigns an appropriate nested name' do
      name = @kernel.foo.bar.baz.to_s
      assert_equal(name, 'configatron.foo.bar.baz')
    end
  end

  describe 'puts' do
    it 'does not cause an exception' do
      puts @kernel
      puts @kernel.hi
    end
  end

  describe 'private methods on kernel' do
    it 'can be accessed through method accessors' do
      @kernel.catch = 'hi'
      @kernel.foo.catch = 'hi'

      assert_equal('hi', @kernel.catch)
      assert_equal('hi', @kernel.foo.catch)
    end
  end

  describe 'to_h and to_hash' do
    before do
      @kernel.a = 1
      @kernel.b.c = Configatron::Delayed.new{ @kernel.a + 3 }
    end

    it 'returns a hash representation' do
      expected_hash = { a: 1, b: { c: 4 } }
      assert_equal(expected_hash, @kernel.to_h)
      assert_equal(expected_hash, @kernel.to_hash)
    end
  end

  describe 'nil value' do
    it 'remembers a nil value' do
      @kernel.a = nil
      assert_equal(nil, @kernel.a)
    end
  end
end

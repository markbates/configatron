require_relative '../_lib'

class Critic::Unit::StoreTest < Critic::Unit::Test
  before do
    @store = Configatron::Store.new(Configatron::RootStore.new)
    @store.foo = 'bar'
  end

  describe "[]" do
    it 'returns the value if there is one' do
      assert_equal('bar', @store[:foo])
      assert_equal('bar', @store['foo'])
    end

    it 'returns a new Configatron::Store object if there is no value' do
      assert_kind_of(Configatron::Store, @store[:unknown])
      assert_kind_of(Configatron::Store, @store['unknown'])
    end

    describe 'Configatron::Proc' do
      it 'executes the proc' do
        @store.a = Configatron::Proc.new {1+1}
        assert_equal(2, @store.a)
      end

    end
  end

  describe '[]=' do
    it "sets the value" do
      @store[:foo] = "bar"
      assert_equal("bar", @store[:foo])
      assert_equal("bar", @store["foo"])

      @store[:baz] = "bazzy"
      assert_equal("bazzy", @store[:baz])
      assert_equal("bazzy", @store["baz"])
    end
  end

  describe "fetch" do
    it "returns the value" do
      assert_equal("bar", @store.fetch(:foo))
      assert_equal("bar", @store.fetch("foo"))
    end

    it "sets and returns the value of the default_value if no value is found" do
      assert_equal("bar!!", @store.fetch(:bar, "bar!!"))
      assert_equal("bar!!", @store.bar)
    end

    it "sets and returns the value of the block if no value is found" do
      @store.fetch(:bar) do
        "bar!"
      end
      assert_equal("bar!", @store.bar)
    end
  end

  describe "key?" do
    it "returns true if there is a key" do
      assert_equal(false, @store.key?(:bar))
      @store.bar = "bar"
      assert_equal(true, @store.key?(:bar))
    end

    it "returns true if the key is a Configatron::Store" do
      assert_equal(false, @store.key?(:bar))
      @store.bar = Configatron::Store.new(Configatron::RootStore.new)
      assert_equal(true, @store.key?(:bar))
    end
  end

  describe "has_key?" do
    it "returns true if there is a key" do
      assert_equal(false, @store.has_key?(:bar))
      @store.bar = "bar"
      assert_equal(true, @store.has_key?(:bar))
    end

    it "returns true if the key is a Configatron::Store" do
      assert_equal(false, @store.has_key?(:bar))
      @store.bar = Configatron::Store.new(Configatron::RootStore.new)
      assert_equal(true, @store.has_key?(:bar))
    end
  end

  describe "method_missing" do
    it "returns the value if there is one" do
      assert_equal("bar", @store.foo)
    end

    it "returns a Configatron::Store if there is no value" do
      assert_kind_of(Configatron::Store, @store.bar)
    end

    it "works with deeply nested values" do
      @store.a.b.c.d = "DD"
      assert_equal("DD", @store.a.b.c.d)
    end

    describe 'with bang' do
      it "raises an exception if the key doesn't exist" do
        assert_raises(Configatron::UndefinedKeyError) do
          @store.a.b!
        end
      end

      it "returns the value" do
        @store.a.b = 'B'
        assert_equal('B', @store.a.b!)
      end
    end
  end

  describe "configuring" do
    describe "configure_from_hash" do
      it "allows setup from a hash" do
        @store.configure_from_hash(one: 1, a: {b: {c: {d: "DD"}}})
        assert_equal(1, @store.one)
        assert_equal("DD", @store.a.b.c.d)
      end
    end

    describe "with a block" do
      before do
        @store.a.b = 'B'
      end

      it "yields up the store to configure with" do
        @store.a do |a|
          a.c = 'CC'
        end
        assert_equal('B', @store.a.b)
        assert_equal('CC', @store.a.c)
      end
    end
  end

  describe '#inspect' do
    it 'returns a printable inspect' do
      store = Configatron::Store.new(Configatron::RootStore.new)

      store.a.b = 'B'
      store.c.d = 'C'
      assert_equal(%{configatron.a.b = "B"\nconfigatron.c.d = "C"}, store.inspect)
    end
  end
end

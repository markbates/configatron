require 'test_helper'

describe Configatron::Store do

  let(:store) { Configatron::Store.new }

  context "[]" do

    let(:store) { Configatron::Store.new(foo: "bar") }

    it "returns the value if there is one" do
      store[:foo].must_equal "bar"
      store["foo"].must_equal "bar"
    end

    it "returns a new Configatron::Store object if there is no value" do
      store[:unknown].must_be_kind_of Configatron::Store
      store["unknown"].must_be_kind_of Configatron::Store
    end

    context 'Configatron::Proc' do

      it 'executes the proc' do
        store.a = Configatron::Proc.new {1+1}
        store.a.must_equal 2
      end

    end

  end

  context "[]=" do

    it "sets the value" do
      store[:foo] = "bar"
      store[:foo].must_equal "bar"
      store["foo"].must_equal "bar"

      store[:baz] = "bazzy"
      store[:baz].must_equal "bazzy"
      store["baz"].must_equal "bazzy"
    end

  end

  context "fetch" do

    let(:store) { Configatron::Store.new(foo: "bar") }

    it "returns the value" do
      store.fetch(:foo).must_equal "bar"
      store.fetch("foo").must_equal "bar"
    end

    it "sets and returns the value of the default_value if no value is found" do
      store.fetch(:bar, "bar!!").must_equal "bar!!"
      store.bar.must_equal "bar!!"
    end

    it "sets and returns the value of the block if no value is found" do
      store.fetch(:bar) do
        "bar!"
      end.must_equal "bar!"
      store.bar.must_equal "bar!"
    end

  end

  context "nil?" do

    it "returns true if there is no value set" do
      store.foo.must_be_nil
      store.foo = "bar"
      store.foo.wont_be_nil
    end

  end

  context "empty?" do

    it "returns true if there is no value set" do
      store.foo.must_be_empty
      store.foo = "bar"
      store.foo.wont_be_empty
    end

  end

  context "key?" do

    it "returns true if there is a key" do
      store.key?(:foo).must_equal false
      store.foo = "bar"
      store.key?(:foo).must_equal true
    end

    it "returns false if the key is a Configatron::Store" do
      store.key?(:foo).must_equal false
      store.foo = Configatron::Store.new
      store.key?(:foo).must_equal false
    end

  end

  context "has_key?" do

    it "returns true if there is a key" do
      store.has_key?(:foo).must_equal false
      store.foo = "bar"
      store.has_key?(:foo).must_equal true
    end

    it "returns false if the key is a Configatron::Store" do
      store.has_key?(:foo).must_equal false
      store.foo = Configatron::Store.new
      store.has_key?(:foo).must_equal false
    end

  end

  context "method_missing" do

    let(:store) { Configatron::Store.new(foo: "bar") }

    it "returns the value if there is one" do
      store.foo.must_equal "bar"
    end

    it "returns a Configatron::Store if there is no value" do
      store.bar.must_be_kind_of Configatron::Store
    end

    it "works with deeply nested values" do
      store.a.b.c.d = "DD"
      store.a.b.c.d.must_equal "DD"
    end

    context 'with bang' do

      it "raises an exception if the key doesn't exist" do
        lambda {store.a.b!}.must_raise Configatron::UndefinedKeyError
      end

      it "returns the value" do
        store.a.b = 'B'
        store.a.b!.must_equal 'B'
      end

    end

  end

  context "lock!" do

    before do
      store.a.b.c.d = 'DD'
      store.lock!
    end

    it "raises an error when accessing non-existing values" do
      store.a.wont_be_nil
      store.a.b.wont_be_nil
      store.a.b.c.wont_be_nil
      store.a.b.c.d.must_equal "DD"
      proc {store.unknown}.must_raise(Configatron::UndefinedKeyError)
    end

    it "raises an error when trying to set a non-existing key" do
      proc {store.unknown = "known"}.must_raise(Configatron::LockedError)
    end

  end

  context "temp" do

    before do
      store.a = 'A'
      store.b = 'B'
    end

    it "allows for temporary setting of values" do
      store.a.must_equal 'A'
      store.b.must_equal 'B'
      store.temp do
        store.a = 'AA'
        store.c = 'C'
        store.a.must_equal 'AA'
        store.b.must_equal 'B'
        store.c.must_equal 'C'
      end
      store.a.must_equal 'A'
      store.b.must_equal 'B'
      store.c.must_be_nil
    end

    context "start/end" do

      it "allows for temporary setting of values" do
        store.a.must_equal 'A'
        store.b.must_equal 'B'
        store.temp_start
        store.a = 'AA'
        store.c = 'C'
        store.a.must_equal 'AA'
        store.b.must_equal 'B'
        store.c.must_equal 'C'
        store.temp_end
        store.a.must_equal 'A'
        store.b.must_equal 'B'
        store.c.must_be_nil
      end

    end

  end

  context "configuring" do

    context "configure_from_hash" do

      it "allows setup from a hash" do
        store.configure_from_hash(one: 1, a: {b: {c: {d: "DD"}}})
        store.one.must_equal 1
        store.a.b.c.d.must_equal "DD"
      end

    end

    context "with a block" do

      before do
        store.a.b = 'B'
      end

      it "yields up the store to configure with" do
        store.a do |a|
          a.c = 'CC'
        end
        store.a.b.must_equal 'B'
        store.a.c.must_equal 'CC'
      end

    end

  end

  context '#inspect' do

    it 'returns a printable inspect' do
      store.a.b = 'B'
      store.c.d = 'C'
      store.inspect.must_equal %{configatron.a.b = "B"\nconfigatron.c.d = "C"}
    end
  end

end

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

  context "configuring" do

    context "configure_from_hash" do

      it "allows setup from a hash" do
        store.configure_from_hash(one: 1, a: {b: {c: {d: "DD"}}})
        store.one.must_equal 1
        store.a.b.c.d.must_equal "DD"
      end

    end

  end

end
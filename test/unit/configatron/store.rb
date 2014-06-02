require_relative '../_lib'

class Critic::Unit::StoreTest < Critic::Unit::Test
  describe Configatron::Store do

    let(:store) { Configatron::Store.new }

    describe "[]" do

      let(:store) { Configatron::Store.new(foo: "bar") }

      it "returns the value if there is one" do
        store[:foo].must_equal "bar"
        store["foo"].must_equal "bar"
      end

      it "returns a new Configatron::Store object if there is no value" do
        store[:unknown].must_be_kind_of Configatron::Store
        store["unknown"].must_be_kind_of Configatron::Store
      end

      describe 'Configatron::Proc' do

        it 'executes the proc' do
          store.a = Configatron::Proc.new {1+1}
          store.a.must_equal 2
        end

      end

    end

    describe "[]=" do

      it "sets the value" do
        store[:foo] = "bar"
        store[:foo].must_equal "bar"
        store["foo"].must_equal "bar"

        store[:baz] = "bazzy"
        store[:baz].must_equal "bazzy"
        store["baz"].must_equal "bazzy"
      end

    end

    describe "fetch" do

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

    describe "nil?" do

      it "returns true if there is no value set" do
        store.foo.must_be_nil
        store.foo = "bar"
        store.foo.wont_be_nil
      end

    end

    describe "empty?" do

      it "returns true if there is no value set" do
        store.foo.must_be_empty
        store.foo = "bar"
        store.foo.wont_be_empty
      end

    end

    describe "key?" do

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

    describe "has_key?" do

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

    describe "method_missing" do

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

      describe 'with bang' do

        it "raises an exception if the key doesn't exist" do
          lambda {store.a.b!}.must_raise Configatron::UndefinedKeyError
        end

        it "returns the value" do
          store.a.b = 'B'
          store.a.b!.must_equal 'B'
        end

      end

    end

    describe "configuring" do

      describe "configure_from_hash" do

        it "allows setup from a hash" do
          store.configure_from_hash(one: 1, a: {b: {c: {d: "DD"}}})
          store.one.must_equal 1
          store.a.b.c.d.must_equal "DD"
        end

      end

      describe "with a block" do

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

    describe '#inspect' do

      it 'returns a printable inspect' do
        store.a.b = 'B'
        store.c.d = 'C'
        store.inspect.must_equal %{configatron.a.b = "B"\nconfigatron.c.d = "C"}
      end
    end
  end
end

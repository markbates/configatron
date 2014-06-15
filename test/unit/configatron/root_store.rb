require_relative '../_lib'

class Critic::Unit::RootTest < Critic::Unit::Test
  before do
    @root = Configatron::RootStore.new
  end

  describe 'delegation' do
    it 'passes on to Configatron::Store' do
      @root.a.b.c.d = 'D'
      assert_equal('D', @root.a.b.c.d)
    end
  end

  describe 'global configatron' do
    it 'returns an instance of Configatron::RootStore' do
      assert_equal(Configatron::RootStore.instance, configatron)
    end
  end

  describe 'inspect' do
    it 'delegates to store' do
      @root.a.b.c.d = 'D'
      @root.a.b.e = 'E'
      assert_equal('configatron.a.b.c.d = "D"
configatron.a.b.e = "E"', @root.inspect)
    end
  end

  describe 'to_s' do
    it 'delegates to store' do
      @root.a.b.c.d = 'D'
      @root.a.b = 'D'
      assert_equal('configatron', @root.to_s)
    end
  end
end

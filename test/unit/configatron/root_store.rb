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
      assert_equal(true, configatron.kind_of?(Configatron::RootStore))
    end
  end
end

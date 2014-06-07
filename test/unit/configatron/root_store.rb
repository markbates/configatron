require_relative '../_lib'

class Critic::Unit::KernelTest < Critic::Unit::Test
  before do
    @kernel = Configatron::RootStore.new
  end

  describe 'delegation' do
    it 'passes on to Configatron::Store' do
      @kernel.a.b.c.d = 'D'
      assert_equal('D', @kernel.a.b.c.d)
    end
  end

  describe 'global configatron' do
    it 'returns an instance of Configatron::RootStore' do
      assert_equal(true, configatron.kind_of?(Configatron::RootStore))
    end
  end
end

require_relative '_lib'

class Critic::Functional::DelayedTest < Critic::Functional::Test
  before do
    @kernel = Configatron::RootStore.new
  end

  describe 'delayed' do
    before do
      @kernel.a = Configatron::Delayed.new { @kernel.b }
      @kernel.b = "expected"
    end

    it 'works independent of the order' do
      assert_equal('expected', @kernel.a)
    end
  end
end

require_relative '../_lib'

class Critic::Unit::ProcTest < Critic::Unit::Test
  before do
    @proc = Configatron::Proc.new {rand}
  end

  describe '#call' do
    it 'executes the block and returns the results' do
      stubs(:rand).returns(4)
      assert_equal(4, @proc.call)
    end

    it 'caches the result if finalize? return true' do
      @proc.stubs(:finalize?).returns(true)
      assert_equal(@proc.call, @proc.call)
    end

    it 'does not cache the result if finalize? returns false' do
      @proc.stubs(:finalize?).returns(false)
      refute_equal(@proc.call, @proc.call)
    end
  end
end

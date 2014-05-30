require_relative '../_lib'

class Critic::Unit::KernelTest < Critic::Unit::Test
  describe Configatron::KernelStore do
    it 'passes on to Configatron::Store' do
      configatron.a.b.c.d = 'D'
      configatron.a.b.c.d.must_equal 'D'
    end
  end

  describe Kernel do
    describe 'configatron' do
      it 'returns an instance of Configatron::KernelStore' do
        configatron.kind_of?(Configatron::KernelStore).must_equal true
      end
    end
  end
end

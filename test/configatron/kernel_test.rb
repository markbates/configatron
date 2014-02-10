require 'test_helper'

describe Configatron::KernelStore do

  let(:store) { Configatron::KernelStore.instance }

  it 'passes on to Configatron::Store' do
    configatron.a.b.c.d = 'D'
    configatron.a.b.c.d.must_equal 'D'
  end

end

describe Kernel do

  describe 'configatron' do

    it 'returns an instance of Configatron::Store' do
      configatron.kind_of?(Configatron::Store).must_equal true
    end

  end

end

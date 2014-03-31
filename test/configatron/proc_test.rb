require 'test_helper'

describe Configatron::Proc do

  let(:store) { Configatron::Store.new }
  let(:proc) { Configatron::Proc.new {rand} }

  describe '#call' do

    it 'executes the block and returns the results' do
      stubs(:rand).returns(4)
      proc.call.must_equal 4
    end

    it 'caches the result if finalize? return true' do
      proc.stubs(:finalize?).returns(true)
      proc.call.must_equal proc.call
    end

    it 'does not cache the result if finalize? returns false' do
      proc.stubs(:finalize?).returns(false)
      proc.call.wont_equal proc.call
    end

  end

end

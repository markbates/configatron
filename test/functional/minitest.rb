require_relative '_lib'
require 'subprocess'

class Critic::Functional::MinitestTest < Critic::Functional::Test
  include Configatron::Integrations::Minitest

  describe 'multiple runs' do
    it 'settings get reset: 1' do
      assert(!configatron.key?(:my_crazy_setting))
      configatron.my_crazy_setting = true
    end

    it 'settings get reset: 2' do
      assert(!configatron.key?(:my_crazy_setting))
      configatron.my_crazy_setting = true
    end
  end
end

require_relative '_lib'
require 'subprocess'

class Critic::Functional::ConfigatronTest < Critic::Functional::Test
  describe 'loading' do
    it 'does not define top-level configatron method if loading configatron/core' do
      Subprocess.check_call([File.expand_path('../_lib/scripts/core.rb', __FILE__)])
    end
  end
end

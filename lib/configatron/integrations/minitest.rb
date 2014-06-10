# Include in a minitest to restore the global configatron object to
# its global state afterwards. Particularly useful if you'd like to test
# your application with various config settings.
#
# ```ruby
# class Test::Suite < Minitest::Unit
#   include Configatron::Integrations::Minitest
#
#   it 'works' do
#     configatron.unlock! do
#       configatron.some.setting = true
#     end
#
#     [...]
#   end
# ```
module Configatron::Integrations
  module Minitest
    def before_setup
      configatron.temp_start
      super
    end

    def before_teardown
      super
      configatron.temp_end
    end
  end
end

require 'singleton'
require 'configatron/version'

require 'configatron/deep_clone'
require 'configatron/errors'
require 'configatron/kernel'
require 'configatron/store'

# Proc *must* load before dynamic/delayed, or else Configatron::Proc
# will refer to the global ::Proc
require 'configatron/proc'
require 'configatron/delayed'
require 'configatron/dynamic'

class Configatron
end

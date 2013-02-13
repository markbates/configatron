# You can require 'configure/core' directly to avoid loading
# configatron's monkey patches (and you can then set
# `Configatron.disable_monkey_patchs = true` to enforce this). If you
# do so, no `configatron` top-level method will be defined for
# you. You can access the configatron object by Configatron.instance.

base = File.join(File.dirname(__FILE__), 'configatron')
require File.join(base, 'core')

if Configatron.disable_monkey_patching
  raise "Cannot require 'configatron' directly, since monkey patching has been disabled. Run `Configatron.disable_monkey_patching = false` to re-enable it, or always require 'configatron/core' to load Configatron."
end

require File.join(base, 'core_ext', 'kernel')
require File.join(base, 'core_ext', 'object')
require File.join(base, 'core_ext', 'string')
require File.join(base, 'core_ext', 'class')

base = File.join(File.dirname(__FILE__), 'configatron')
if RUBY_VERSION.match(/^1\.9\.2/)
  require 'syck'
  ::YAML::ENGINE.yamler = 'syck'
end
require 'yamler'
require 'fileutils'
require File.join(base, 'configatron')
require File.join(base, 'store')
require File.join(base, 'errors')
require File.join(base, 'core_ext', 'kernel')
require File.join(base, 'core_ext', 'object')
require File.join(base, 'core_ext', 'string')
require File.join(base, 'core_ext', 'class')
require File.join(base, 'rails')
require File.join(base, 'proc')

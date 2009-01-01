base = File.join(File.dirname(__FILE__), 'configatron')
require 'yaml'
require File.join(base, 'kernel')
require File.join(base, 'configatron')
require File.join(base, 'store')
require File.join(base, 'errors')

class Object
  alias_method :send!, :send if RUBY_VERSION > '1.9.0'
  
  # if RUBY_VERSION > '1.9.0'
  #   def send(*args)
  #     __send!(*args)
  #   end
  # end
end
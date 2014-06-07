#!/usr/bin/env ruby

if defined?(configatron)
  raise "`configatron` method was defined at load-time!"
end

require 'configatron/core'

if defined?(configatron)
  raise "Loaded configatron/core but `configatron` was defined!"
end

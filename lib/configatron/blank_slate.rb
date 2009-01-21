#--
# Copyright 2004, 2006 by Jim Weirich (jim@weirichhouse.org).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#++

# This version of BlankSlate was taken from Builder and modified by Rob Sanheim
# to remove hooks into the various built-in callbacks (ie method_added).
# Not sure if we need that complexity (yet) in configatron's use case.
#
######################################################################
# BlankSlate provides an abstract base class with no predefined
# methods (except for <tt>\_\_send__</tt> and <tt>\_\_id__</tt>).
# BlankSlate is useful as a base class when writing classes that
# depend upon <tt>method_missing</tt> (e.g. dynamic proxies).
#
class Configatron
  class BlankSlate
    # These methods are used by configatron internals, so we have to whitelist them.
    # We could probably do some alias magic to get them to be proper __foo style methods
    #, but this is okay for now.
    CONFIGATRON_WHITELIST = %w[instance_eval methods instance_variable_get is_a? class]
    
    class << self
      
      # Hide the method named +name+ in the BlankSlate class.  Don't
      # hide methods in +CONFIGATRON_WHITELIST+ or any method beginning with "__".
      def hide(name)
        if instance_methods.include?(name.to_s) and
          name !~ /^(__|#{CONFIGATRON_WHITELIST.join("|")})/
          @hidden_methods ||= {}
          @hidden_methods[name.to_sym] = instance_method(name)
          undef_method name
        end
      end

      def find_hidden_method(name)
        @hidden_methods ||= {}
        @hidden_methods[name] || superclass.find_hidden_method(name)
      end

      # Redefine a previously hidden method so that it may be called on a blank
      # slate object.
      def reveal(name)
        bound_method = nil
        unbound_method = find_hidden_method(name)
        fail "Don't know how to reveal method '#{name}'" unless unbound_method
        define_method(name) do |*args|
          bound_method ||= unbound_method.bind(self)
          bound_method.call(*args)
        end
      end
    end

    instance_methods.each { |m| hide(m) }
    
  end
end
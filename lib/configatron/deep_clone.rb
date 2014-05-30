module Configatron::DeepClone
  # = DeepClone
  #
  # == Version
  #  1.2006.05.23.configatron.1 (change of the first number means Big Change)
  #
  # == Description
  #  Adds deep_clone method to an object which produces deep copy of it. It means
  #  if you clone a Hash, every nested items and their nested items will be cloned.
  #  Moreover deep_clone checks if the object is already cloned to prevent endless recursion.
  #
  # == Usage
  #
  #  (see examples directory under the ruby gems root directory)
  #
  #   require 'rubygems'
  #   require 'deep_clone'
  #
  #   include DeepClone
  #
  #   obj = []
  #   a = [ true, false, obj ]
  #   b = a.deep_clone
  #   obj.push( 'foo' )
  #   p obj   # >> [ 'foo' ]
  #   p b[2]  # >> []
  #
  # == Source
  # http://simplypowerful.1984.cz/goodlibs/1.2006.05.23
  #
  # == Author
  #  jan molic (/mig/at_sign/1984/dot/cz/)
  #
  # == Licence
  #  You can redistribute it and/or modify it under the same terms of Ruby's license;
  #  either the dual license version in 2003, or any later version.
  def self.deep_clone( obj=self, cloned={} )
    if obj.kind_of?(Configatron::KernelStore)
      # We never actually want to have multiple copies of our
      # Configatron::KernelStore (and every Store has a reference).
      return obj
    elsif cloned.has_key?( obj.object_id )
      return cloned[obj.object_id]
    else
      begin
        cl = obj.clone
      rescue Exception
        # unclonnable (TrueClass, Fixnum, ...)
        cloned[obj.object_id] = obj
        return obj
      else
        cloned[obj.object_id] = cl
        cloned[cl.object_id] = cl
        if cl.is_a?( Hash )
          cl.clone.each { |k,v|
            cl[k] = deep_clone( v, cloned )
          }
        elsif cl.is_a?( Array )
          cl.collect! { |v|
            deep_clone( v, cloned )
          }
        end
        cl.instance_variables.each do |var|
          v = cl.instance_eval( var.to_s )
          v_cl = deep_clone( v, cloned )
          cl.instance_eval( "#{var} = v_cl" )
        end
        return cl
      end
    end
  end
end

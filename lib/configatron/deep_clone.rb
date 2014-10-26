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
    if Configatron::RootStore === obj
      # We never actually want to have multiple copies of our
      # Configatron::RootStore -- when making a temp, we just stick
      # the state-to-revert-to into an ivar.
      return obj
    elsif Configatron::Store === obj
      # Need to special-case this since it's a BasicObject, meaning it
      # doesn't respond to all the usual ivar magic methods
      cl = obj.clone(cloned)
      cloned[obj.__id__] = cl
      cloned[cl.__id__] = cl
      return cl
    elsif cloned.key?( obj.__id__ )
      return cloned[obj.__id__]
    else
      begin
        cl = obj.clone
      rescue Exception
        # unclonnable (TrueClass, Fixnum, ...)
        cloned[obj.__id__] = obj
        return obj
      else
        cloned[obj.__id__] = cl
        cloned[cl.__id__] = cl
        case
        when Hash === cl
          cl.clone.each do |k,v|
            cl[k] = deep_clone( v, cloned )
          end
        when Array === cl
          cl.collect! do |v|
            deep_clone( v, cloned )
          end
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

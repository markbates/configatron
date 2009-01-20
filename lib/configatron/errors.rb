class Configatron
  class ProtectedParameter < RuntimeError
    def initialize(_name)
      super("Can not modify protected parameter: '#{_name}'")
    end
  end

  class LockedNamespace < RuntimeError
    def initialize(_name)
      super("Cannot add new parameters to locked namespace: #{_name.inspect}")
    end
  end
end

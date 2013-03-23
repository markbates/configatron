class Configatron
  class ProtectedParameter < StandardError
    def intialize(name)
      super("Can not modify protected parameter: '#{name}'")
    end
  end

  class LockedNamespace < StandardError
    def initialize(name)
      super("Cannot add new parameters to locked namespace: #{name.inspect}")
    end
  end

  class RequiredParameter < StandardError
    def initialize(name)
      super("Required parameter missing: #{name.inspect}")
    end
  end
end

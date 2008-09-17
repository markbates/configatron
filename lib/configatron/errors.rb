class Configatron
  class ProtectedParameter < StandardError
    def intialize(name)
      super("Can not modify protected parameter: '#{name}'")
    end
  end
end
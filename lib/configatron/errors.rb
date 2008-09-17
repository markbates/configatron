class Configatron
  class FrozenParameter < StandardError
    def intialize(name)
      super("Can not modify frozen parameter: '#{name}'")
    end
  end
end
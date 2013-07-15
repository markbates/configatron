class Configatron
  class UndefinedKeyError < StandardError
    def initialize(msg)
      super(msg)
    end
  end
  class LockedError < StandardError
  end
end
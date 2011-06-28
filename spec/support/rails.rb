module Rails
  class << self
    attr_accessor :env
    attr_accessor :root
    attr_accessor :logger
  end
end
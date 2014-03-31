class Configatron

  class Proc

    attr_accessor :execution_count
    attr_accessor :block

    def initialize(&block)
      self.execution_count = 0
      self.block = block
    end

    def call
      unless @val
        val = self.block.call
        self.execution_count += 1
        if finalize?
          @val = val
        end
      end
      return val || @val
    end

    def finalize?
      true
    end

    def inspect
      call.inspect
    end

  end

end

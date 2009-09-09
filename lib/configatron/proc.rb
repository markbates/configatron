class Configatron
  class Proc

    attr_accessor :execution_count
    attr_accessor :block
    
    def initialize(&block)
      self.execution_count = 0
      self.block = block
    end
    
    def execute
      val = self.block.call
      self.execution_count += 1
      return val
    end
    
    def finalize?
      self.execution_count == 1
    end
    
  end
  
  class Dynamic < Configatron::Proc
    def finalize?
      false
    end
  end
  
  class Delayed < Configatron::Proc
  end
  
end
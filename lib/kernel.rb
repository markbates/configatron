module Kernel
  
  def configatron(&block)
    if block_given?
      Configatron::Configuration.instance.configure(&block)
    else
      Configatron::Configuration.instance
    end
  end
  
end
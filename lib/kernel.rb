module Kernel
  
  # If called without a block it will return the Configatron::Configuration instance.
  # If called with a block then it will call the Configatron::Configatron configure method
  # and yield up a Configatron::Store object.
  def configatron(&block)
    if block_given?
      Configatron::Configuration.instance.configure(&block)
    else
      Configatron::Configuration.instance
    end
  end
  
end
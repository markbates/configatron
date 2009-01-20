class Class
  
  # Returns access to configuration parameters named after the class.
  # 
  # Examples:
  #   configatron.foo.bar = :bar
  #   configatron.a.b.c.d = 'D'
  #   
  #   class Foo
  #   end
  #   
  #   module A
  #     module B
  #       class C
  #       end
  #     end
  #   end
  # 
  #   Foo.to_configatron.bar # => :bar
  #   A::B::C.to_configatron.d # => 'D'
  def to_configatron
    name_spaces = self.name.split("::").collect{|s| s.methodize}
    configatron.send_with_chain(name_spaces)
  end
  
end
require 'forwardable'

class Configatron
  class Store# < BasicObject
    extend ::Forwardable

    def initialize(attributes = {})
      @__locked = false
      @attributes = attributes || {}
      @attributes.send(:extend, DeepClone)
    end

    def lock!
      @__locked = true
    end

    def [](key)
      fetch(key.to_sym) do
        if @__locked
          raise Configatron::UndefinedKeyError.new("Key Not Found: #{key}")
        end
        ::Configatron::Store.new
      end
    end

    def store(key, value)
      if @__locked
        raise Configatron::LockedError.new("Locked! Can not set key #{key}!")
      end
      @attributes[key.to_sym] = value
    end

    def fetch(key, default_value = nil, &block)
      val = @attributes[key.to_sym]
      if val.nil?
        if block_given?
          val = block.call
        elsif default_value
          val = default_value
        end
        store(key, val)
      end
      return val
    end

    def nil?
      @attributes.empty?
    end

    def has_key?(key)
      val = self[key]
      !val.is_a?(Configatron::Store)
    end

    def configure_from_hash(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          self[key].configure_from_hash(value)
        else
          store(key, value)
        end
      end
    end

    def temp(&block)
      @__temp = @attributes.deep_clone
      yield
      @attributes = @__temp
    end

    def method_missing(name, *args, &block)
      if block_given?
        yield self[name]
      else
        name = name.to_s
        if /(.+)=$/.match(name)
          return store($1, args[0])
        else
          return self[name]
        end
      end
    end


    def print
      internal_print_hash("", self)
    end

    def internal_print_hash(key_up_here, hash)
      if key_up_here.blank?
        starting_with = ""
      else
        starting_with = "#{key_up_here}."
      end

      hash.each { |key,value|  
      
        if value.is_a?(Store)
          internal_print_hash("#{starting_with}#{key}", value)
        else
          puts "#{starting_with}#{key}=#{value}"
        end

      }
      
    end


    alias :[]= :store
    alias :blank? :nil?

    def_delegator :@attributes, :values
    def_delegator :@attributes, :keys
    def_delegator :@attributes, :each
    def_delegator :@attributes, :empty?
    def_delegator :@attributes, :inspect
    def_delegator :@attributes, :to_h
    def_delegator :@attributes, :to_hash
    def_delegator :@attributes, :delete
    # def_delegator :@attributes, :fetch
    # def_delegator :@attributes, :has_key?
    # def_delegator :$stdout, :puts

  end
end
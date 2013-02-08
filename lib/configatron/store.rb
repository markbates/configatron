require 'forwardable'

class Configatron
  class Store# < BasicObject
    extend ::Forwardable

    def initialize(attributes = {})
      @attributes = attributes || {}
    end

    def [](key)
      fetch(key.to_sym) do
        ::Configatron::Store.new
      end
    end

    def store(key, value)
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

    def method_missing(name, *args, &block)
      # puts %{name: #{name.inspect}}
      name = name.to_s
      if /(.+)=$/.match(name)
        return store($1, args[0])
      else
        return self[name]
      end
    end

    alias :[]= :store
    alias :blank? :nil?

    def_delegator :@attributes, :values
    def_delegator :@attributes, :keys
    def_delegator :@attributes, :each
    def_delegator :@attributes, :empty?
    def_delegator :@attributes, :inspect
    # def_delegator :@attributes, :fetch
    # def_delegator :@attributes, :has_key?
    # def_delegator :$stdout, :puts

  end
end
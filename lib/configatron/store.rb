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
      val = fetch(key.to_sym) do
        if @__locked
          raise Configatron::UndefinedKeyError.new("Key Not Found: #{key}")
        end
        ::Configatron::Store.new
      end
      return val
    end

    def dup
      ::Configatron::Store.new(@attributes.dup)
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
      if val.is_a?(Configatron::Proc)
        val = val.call
      end
      return val
    end

    def nil?
      @attributes.empty?
    end

    def key?(key)
      val = self[key.to_sym]
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
      temp_start
      yield
      temp_end
    end

    def temp_start
      @__temp = @attributes.deep_clone
    end

    def temp_end
      @attributes = @__temp
    end

    def method_missing(name, *args, &block)
      if block_given?
        yield self[name]
      else
        name = name.to_s
        if /(.+)=$/.match(name)
          return store($1, args[0])
        elsif /(.+)!/.match(name)
          key = $1
          if self.has_key?(key)
            return self[key]
          else
            raise Configatron::UndefinedKeyError.new($1)
          end
        else
          return self[name]
        end
      end
    end

    def inspect(name = 'configatron')
      f_out = []
      @attributes.each do |k, v|
        if v.is_a?(Configatron::Store)
          v.inspect("#{name}.#{k}").each_line do |line|
            if line.match(/\n/)
              line.each_line do |l|
                l.strip!
                f_out << l
              end
            else
              line.strip!
              f_out << line
            end
          end
        else
          f_out << "#{name}.#{k} = #{v.inspect}"
        end
      end
      f_out.compact.sort.join("\n")
  end

    alias :[]= :store
    alias :blank? :nil?
    alias :has_key? :key?

    def_delegator :@attributes, :values
    def_delegator :@attributes, :keys
    def_delegator :@attributes, :each
    def_delegator :@attributes, :empty?
    def_delegator :@attributes, :to_h
    def_delegator :@attributes, :to_hash
    def_delegator :@attributes, :delete
    # def_delegator :@attributes, :fetch
    # def_delegator :@attributes, :has_key?
    # def_delegator :$stdout, :puts

  end
end

require 'forwardable'

class Configatron
  class Store < BasicObject
    extend ::Forwardable

    def initialize(root_store, name='configatron', attributes={}, path=[])
      @root_store = root_store
      @name = name
      @attributes = attributes

      # We could derive @name from @path, though this would break
      # backwards-compatibility.
      @path = path

      @cow = root_store.__cow
    end

    def clone
      Store.new(
        @root_store,
        @name,
        @attributes.clone,
        @path
        )
    end

    def __cow
      @cow
    end

    def __cow_clone
      # A temp has started since the last time this was written
      if @root_store.__cow != @cow
        self.clone
      else
        self
      end
    end

    def [](key)
      val = fetch(key.to_sym) do
        if @root_store.locked?
          ::Kernel.raise ::Configatron::UndefinedKeyError.new("Key not found: #{key} (for locked #{self})")
        end
        ::Configatron::Store.new(@root_store, "#{@name}.#{key}", {}, @path + [key])
      end
      return val
    end

    def store(key, value)
      if @root_store.locked?
        ::Kernel.raise ::Configatron::LockedError.new("Cannot set key #{key} for locked #{self}")
      end

      key = key.to_sym
      if @root_store.__cow != @cow
        copy = @root_store.__cow_path(@path)
        # Cow should now match, so this won't recurse. (Note this is
        # not particularly thread-safe.)
        copy.store(key, value)
      else
        @attributes[key] = value
      end
    end

    def fetch(key, default_value = nil, &block)
      key = key.to_sym
      if key?(key)
        val = @attributes[key]
      else
        if block
          val = block.call
        elsif default_value
          val = default_value
        end
        store(key, val)
      end
      if ::Configatron::Proc === val
        val = val.call
      end
      return val
    end

    def key?(key)
      @attributes.key?(key.to_sym)
    end

    def configure_from_hash(hash)
      hash.each do |key, value|
        if ::Hash === value
          self[key].configure_from_hash(value)
        else
          store(key, value)
        end
      end
    end

    def to_s
      @name
    end

    def inspect
      f_out = []
      @attributes.each do |k, v|
        if ::Configatron::Store === v
          v.inspect.each_line do |line|
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
          f_out << "#{@name}.#{k} = #{v.inspect}"
        end
      end
      f_out.compact.sort.join("\n")
    end

    def method_missing(name, *args, &block)
      do_lookup(name, *args, &block)
    end

    def to_h
      @attributes.each_with_object({}) do |(k, v), h|
        v = v.call if ::Configatron::Proc === v
        h[k] = Store === v ? v.to_h : v
      end
    end

    # So that puts works (it expects the object to respond to to_ary)
    def to_ary
      nil
    end

    # So that we keep backward-compatibility in case people are using nil? to check
    # configatron settings:
    def nil?
      false
    end

    private

    def do_lookup(name, *args, &block)
      if block
        yield self[name]
      else
        name = name.to_s
        if name.end_with?('=')
          return store(name[0..-2], args[0])
        elsif name.end_with?('!')
          key = name[0..-2]
          if self.has_key?(key)
            return self[key]
          else
            ::Kernel.raise ::Configatron::UndefinedKeyError.new($1)
          end
        else
          return self[name]
        end
      end
    end

    alias :[]= :store
    alias :has_key? :key?
    alias :to_hash :to_h

    def_delegator :@attributes, :values
    def_delegator :@attributes, :keys
    def_delegator :@attributes, :each
    def_delegator :@attributes, :delete
    # def_delegator :@attributes, :fetch
    # def_delegator :@attributes, :has_key?
    # def_delegator :$stdout, :puts

  end
end

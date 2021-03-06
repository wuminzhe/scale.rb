class String
  def to_snake
    self.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .downcase
  end
end

module ScaleBytes
  attr_reader :bytes
  attr_accessor :offset

  def init_bytes(data)
    if data.class.to_s == 'Array' and data.all? {|e| e >= 0 and e <= 255 }
      raise "Provided data's length is not correct, #{self.class} expect #{self.class::BYTES_LENGTH} but #{arr.length}" if self.class::BYTES_LENGTH != data.length
      @bytes = data
    elsif data.class.to_s == 'String' and data.start_with?('0x') and data.length % 2 == 0
      arr = data[2..].scan(/../).map(&:hex)
      raise "Provided data's length is not correct, #{self.class} expect #{self.class::BYTES_LENGTH} but #{arr.length}" if self.class::BYTES_LENGTH != arr.length
      @bytes = arr
    else
      raise "Provided data is not valid"
    end

    @offset = 0
  end

  def reset_offset
    @offset = 0
  end

  def get_next_bytes(length)
    result = @bytes[@offset ... @offset + length]
    @offset = @offset + length
    return result
  end

  def to_hex
    @bytes.reduce('0x') { |hex, byte| hex + byte.to_s(16).rjust(2, '0') }
  end

  def to_bin
    @bytes.reduce('0b') { |bin, byte| bin + byte.to_s(2).rjust(8, '0') }
  end

  def ==(another_object)
    self.bytes == another_object.bytes
  end
end

module SingleValue
  include ScaleBytes
  attr_reader :value

  def initialize(data)
    init_bytes(data)
    # from raw @bytes to @value
    decode
  end

  # TODO: better format
  def to_s
    %Q{type: #{self.class}
    value: #{@value}
    hex: #{to_hex}
    bin: #{to_bin}
}
  end

  def ==(another_object)
    self.bytes == another_object.bytes && self.value == another_object.value
  end
end

module Primitive
  include SingleValue

  def self.encode(value)
    raise NotImplementedError
  end
end

module FixedWidthUInt
  include Primitive

  def decode
    bytes_reversed = @bytes.reverse
    hex = bytes_reversed.reduce('0x') { |hex, byte| hex + byte.to_s(16).rjust(2, '0') }
    @value = hex.to_i(16)
  end

  module ClassMethods
    def encode(value)
      class_name = self.to_s
      # 16 32 64 ...
      bits = class_name.split("::").last[1..].to_i
      bin_str = value.to_s(2).rjust(bits, '0')
      bytes = bin_str.scan(/([01]{8})/).map { |byte| byte[0].to_i(2) }.reverse
      self.new(bytes)
    end
  end

  def self.included(host)
    host.extend(ClassMethods)

    # define to_uX(to_u16, to_u32, ..) method
    class_name = host.to_s
    method_name = "to_#{class_name.split("::").last.downcase}"
    Integer.send(:define_method, method_name.to_sym) do
      clazz = Object.const_get class_name
      clazz.encode self
    end
  end
end

module CompactUInt
  include ScaleBytes
  attr_reader :value

  def initialize(data)
    init_bytes(data)
    decode
  end

  def decode
    @value = 
      if @bytes.length == 1
        byte = @bytes[0].to_s(2).rjust(8, '0')

        ('00' + byte[0 .. 5]).to_i(2)
      elsif @bytes.length == 2
        byte0 =  @bytes[0].to_s(2).rjust(8, '0')
        byte1 =  @bytes[1].to_s(2).rjust(8, '0')

        fst_byte_str = '00' + byte1[0 .. 5]
        sec_byte_str = byte1[6 .. 7] + byte0[0 .. 5]

        (fst_byte_str + sec_byte_str).to_i(2)
      elsif @bytes.length == 4
        byte0 =  @bytes[0].to_s(2).rjust(8, '0')
        byte1 =  @bytes[1].to_s(2).rjust(8, '0')
        byte2 =  @bytes[2].to_s(2).rjust(8, '0')
        byte3 =  @bytes[3].to_s(2).rjust(8, '0')

        fst_byte_str = '00' + byte3[0 .. 5]
        sec_byte_str = byte3[6 .. 7] + byte2[0 .. 5]
        thd_byte_str = byte2[6 .. 7] + byte1[0 .. 5]
        fth_byte_str = byte1[6 .. 7] + byte0[0 .. 5]

        (fst_byte_str + sec_byte_str + thd_byte_str + fth_byte_str).to_i(2)
      end
  end

  def to_s
%Q{type: #{self.class}
bytes: #{@bytes.to_s}
hex  : #{to_hex}
bin  : #{to_bin}
value: #{@value}
}
  end

  module ClassMethods
    def encode(value)
      bytes = 
        if value <= 63
          bin_str = value.to_s(2).rjust(8, '0')[2 .. 7] + '00'
          [bin_str.to_i(2)]
        elsif value <= (2**14-1)
          bin_str = value.to_s(2).rjust(16, '0')[2..] + '01'
          [bin_str[8..].to_i(2), bin_str[0..7].to_i(2)]
        elsif value <= (2**30-1)
          bin_str = value.to_s(2).rjust(32, '0')[2..] + '10'
          [bin_str[24..].to_i(2), bin_str[16..23].to_i(2), bin_str[8..15].to_i(2), bin_str[0..7].to_i(2)]
        end
      self.new(bytes)
    end
  end

  def self.included(host)
    host.extend(ClassMethods)

    # define to_compactX(to_compact8) method
    class_name = host.to_s
    method_name = "to_#{class_name.split("::").last.to_snake}"
    Integer.send(:define_method, method_name.to_sym) do
      clazz = Object.const_get class_name
      clazz.encode self
    end
  end
end


module StructBase
  include ScaleBytes

  # new(1.to_u32, U32(69)) or new('0x0100000045000000') or new([1, 0, 0, 0, 69, 0, 0, 0])
  def initialize(*args)
    if args.length == 1 && (args[0].class.to_s == 'Array' || args[0].class.to_s == 'String')
      init_bytes(args[0])
      # puts self.class.instance_methods(false)
      decode
    else
      raise ArgumentError, "Too many arguments" if args.size > self.class::ATTRIBUTES.size
      @bytes = []
      self::class::ATTRIBUTES.zip(args) do |attr, val|
        send "#{attr}=", val
        @bytes = @bytes + val.bytes
      end
    end

  end

  def decode
    reset_offset
    self::class::ATTRIBUTES.each_with_index do |attr, i|
      attr_type = self::class::ATTRIBUTE_TYPES[i]
      send "#{attr}=", attr_type.new(get_next_bytes(attr_type::BYTES_LENGTH))
    end
  end

  module ClassMethods
    def items(**items)
      attrs = []
      attr_types = []

      items.each_pair do |attr_name, attr_type|
        attrs << attr_name
        attr_types << attr_type
      end

      self.const_set(:ATTRIBUTES, attrs)
      self.const_set(:ATTRIBUTE_TYPES, attr_types)
      self.const_set(:BYTES_LENGTH, attr_types.reduce(0) {|length, type| length + type::BYTES_LENGTH})
      self.attr_accessor *attrs
    end
  end
  
  def self.included(host)
    host.extend ClassMethods
  end
end


module Some
  include SingleValue

  def initialize(data)
    if data.is_a? self.class::VALUE_TYPE
      @value = data
      @types = [1] + data.bytes
    else
      super(data)
    end
  end

  def decode
    @value = self::class::VALUE_TYPE.new @bytes[1..]
  end

  module ClassMethods
    def set_value_type(value_type)
      self.const_set :VALUE_TYPE, value_type
      self.const_set :BYTES_LENGTH, value_type::BYTES_LENGTH + 1
    end
  end

  def self.included(host)
    host.extend ClassMethods
  end
end

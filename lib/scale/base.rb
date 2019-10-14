module ScaleBytes
  attr_reader :bytes

  def init_bytes(data)
    if data.class.to_s == 'Array' and data.all? {|e| e >= 0 and e <= 255 }
      @bytes = data
    elsif data.class.to_s == 'String' and data.start_with?('0x') and data.length % 2 == 0
      @bytes = data[2..].scan(/../).map(&:hex)
    else
      raise "Provided data is not valid"
    end
  end

  def to_hex
    @bytes.reduce('0x') { |hex, byte| hex + byte.to_s(16).rjust(2, '0') }
  end

  def to_bin
    @bytes.reduce('0b') { |bin, byte| bin + byte.to_s(2).rjust(8, '0') }
  end
end

module UInt
  include ScaleBytes
  attr_reader :value

  def initialize(data)
    init_bytes(data)
    decode
  end

  def decode
    bytes_reversed = @bytes.reverse
    hex = bytes_reversed.reduce('0x') { |hex, byte| hex + byte.to_s(16).rjust(2, '0') }
    @value = hex.to_i(16)
  end

  # TODO: better format
  def to_s
    "type: #{self.class}\nvalue: #{@value}\nhex: #{to_hex}\nbin: #{to_bin}"
  end

  def ==(another_object)
    self.bytes == another_object.bytes && self.value == another_object.value
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

    # define to_xx(to_16, to_32, ..) method
    class_name = host.to_s
    method_name = "to_#{class_name.split("::").last.downcase}"
    Integer.send(:define_method, method_name.to_sym) do
      clazz = Object.const_get class_name
      clazz.encode self
    end
  end
end

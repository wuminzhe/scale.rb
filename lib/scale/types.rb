module Scale
  module Types
    # fixed with integer
    class U16
      include UInt
    end

    class U32
      include UInt
    end

    class U64
      include UInt
    end

    # compact integer
    class Compact
      include ScaleBytes
      attr_reader :value

      def initialize(data)
        init_bytes(data)
        decode
      end

      def self.encode(value)
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
        Compact.new(bytes)
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
    end

    Integer.send(:define_method, :to_compact) do
      Compact.encode self
    end
    # end compact integer

  end
end

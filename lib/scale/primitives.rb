module Scale
  module Types

    class Bool
      include Primitive
      BYTES_LENGTH = 1

      def decode
        @value = 
          if @bytes == [1]
            true
          elsif @bytes == [0]
            false
          else
            # TODO: add custom exception
            raise "The data is not correct for #{self.class}"
          end
      end

      def self.encode(value)
        bytes = value === true ? [1] : [0]
        Bool.new(bytes)
      end
    end

    class H256
      include Primitive
      BYTES_LENGTH = 32

      def decode
        @value = to_hex
      end
    end

    class H512
      include Primitive
      BYTES_LENGTH = 64

      def decode
        @value = to_hex
      end
    end

    class AccountId < H256; end

    class Balance < U128; end

  end
end

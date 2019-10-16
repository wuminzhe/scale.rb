module Scale
  module Types

    class None
      include SingleValue
      BYTES_LENGTH = 1

      def initialize
        @value = nil
        @bytes = [0]
      end
    end

    class SomeU32
      include Some

      set_value_type Scale::Types::U32
    end

    # module IntOrBool
      # MEMBERS = [:Int, :Bool]

      # class Int 
        # include ScaleBytes
        # INNER_TYPE = Scale::Types::U8
        # BYTES_LENGTH = INNER_TYPE::BYTES_LENGTH + 1
        # attr_accessor :inner

        # def initialize(data)
          # if data.class.to_s == 'String' and data.start_with?('0x') and data.length % 2 == 0
            # @bytes = data[2..].scan(/../).map(&:hex)
            # raise "Provided data's length is not correct, #{self.class} expect #{self.class::BYTES_LENGTH} but #{arr.length}" if self.class::BYTES_LENGTH != @bytes.length
            # @inner = self.class::INNER_TYPE.new(@bytes[1..])
          # end
        # end
      # end

      # class Bool
        # include ScaleBytes
        # INNER_TYPE = Scale::Types::Bool
        # BYTES_LENGTH = INNER_TYPE::BYTES_LENGTH + 1
        # attr_accessor :inner

        # def initialize(data)
          # if data.class.to_s == 'String' and data.start_with?('0x') and data.length % 2 == 0
            # @bytes = data[2..].scan(/../).map(&:hex)
            # raise "Provided data's length is not correct, #{self.class} expect #{self.class::BYTES_LENGTH} but #{arr.length}" if self.class::BYTES_LENGTH != @bytes.length
            # @inner = self.class::INNER_TYPE.new(@bytes[1..])
          # end
        # end
      # end
    # end



    class Student
      include StructBase

      items(
        age: Scale::Types::U32, 
        grade: Scale::Types::U32
      )
    end

    class RawBabePreDigestSecondary
      include StructBase

      items(
        authorityIndex: Scale::Types::U32, 
        slotNumber: Scale::Types::U64,
        weight: Scale::Types::U32
      )
    end

    class RawBabePreDigestPrimary
      include StructBase

      items(
        authorityIndex: Scale::Types::U32, 
        slotNumber: Scale::Types::U64,
        weight: Scale::Types::U32,
        vrfOutput: Scale::Types::H256,
        vrfProof: Scale::Types::H512
      )
    end
  end
end

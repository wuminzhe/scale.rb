module Scale
  module Types

    class H256
      include ScaleBytes
      BYTES_LENGTH = 32
      def initialize(data)
        init_bytes(data)
      end
    end

    class H512
      include ScaleBytes
      BYTES_LENGTH = 64
      def initialize(data)
        init_bytes(data)
      end
    end

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

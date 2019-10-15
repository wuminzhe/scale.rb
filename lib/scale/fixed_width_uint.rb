module Scale
  module Types
    # fixed width integer
    class U16
      include UInt
      BYTES_LENGTH = 2
    end

    class U32
      include UInt
      BYTES_LENGTH = 4
    end

    class U64
      include UInt
      BYTES_LENGTH = 8
    end

    class U256
      include UInt
      BYTES_LENGTH = 32
    end

    class U512
      include UInt
      BYTES_LENGTH = 64
    end
  end
end

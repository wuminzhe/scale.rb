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


  end
end

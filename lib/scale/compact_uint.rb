module Scale
  module Types

    class CompactU8
      include CompactUInt
      BYTES_LENGTH = 1
    end

    class CompactU16
      include CompactUInt
      BYTES_LENGTH = 2
    end

    class CompactU32
      include CompactUInt
      BYTES_LENGTH = 4
    end
  end
end

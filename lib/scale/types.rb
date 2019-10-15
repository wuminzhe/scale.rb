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

  end
end

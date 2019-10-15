module Scale
  module Types

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
    end

    # class Student
    #   include ScaleBytes
    #   ATTRIBUTES = [:age, :grade]
    #   ATTRIBUTE_TYPES = [U32, U32]
    #   BYTES_LENGTH = ATTRIBUTE_TYPES.reduce(0) {|length, type| length + type::BYTES_LENGTH}

    #   attr_accessor *ATTRIBUTES

    #   # new(1.to_u32, U32(69)) or new('0x0100000045000000') or new([1, 0, 0, 0, 69, 0, 0, 0])
    #   def initialize(*args)
    #     if args.length == 1 && (args[0].class.to_s == 'Array' || args[0].class.to_s == 'String')
    #       init_bytes(args[0])
    #       # puts self.class.instance_methods(false)
    #       decode
    #     else
    #       raise ArgumentError, "Too many arguments" if args.size > ATTRIBUTES.size
    #       @bytes = []
    #       ATTRIBUTES.zip(args) do |attr, val|
    #         send "#{attr}=", val
    #         @bytes = @bytes + val.bytes
    #       end
    #     end
    #   end

    #   def decode
    #     reset_offset
    #     ATTRIBUTES.each_with_index do |attr, i|
    #       attr_type = ATTRIBUTE_TYPES[i]
    #       send "#{attr}=", attr_type.new(get_next_bytes(attr_type::BYTES_LENGTH))
    #     end
    #   end
    # end

    class Student
      include StructBase

      ATTRIBUTES = [:age, :grade]
      ATTRIBUTE_TYPES = [U32, U32]
      BYTES_LENGTH = ATTRIBUTE_TYPES.reduce(0) {|length, type| length + type::BYTES_LENGTH}
      attr_accessor *ATTRIBUTES
    end


  end
end

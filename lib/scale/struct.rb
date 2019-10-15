module Scale
  module Types

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

require 'scale'

describe Scale::Types::U32 do
  it "can create from scale bytes array" do
    u32_69 = Scale::Types::U32.new([69, 0, 0, 0])
    expect(u32_69.value).to eql(69)
    expect(u32_69.bytes).to eql([69, 0, 0, 0])
    expect(u32_69.to_hex).to eql('0x45000000')
    expect(u32_69.to_bin).to eql('0b01000101000000000000000000000000')

  end

  it "can create from scale hex string" do
    u32_69 = Scale::Types::U32.new('0x45000000')
    expect(u32_69.value).to eql(69)
    expect(u32_69.bytes).to eql([69, 0, 0, 0])
    expect(u32_69.to_hex).to eql('0x45000000')
    expect(u32_69.to_bin).to eql('0b01000101000000000000000000000000')
  end

  it "can create from encoding a integer" do
    u32_69 = 69.to_u32
    expect(u32_69.value).to eql(69)
    expect(u32_69.bytes).to eql([69, 0, 0, 0])
    expect(u32_69.to_hex).to eql('0x45000000')
    expect(u32_69.to_bin).to eql('0b01000101000000000000000000000000')
  end
end


describe Scale::Types::U64 do
  it "can create from scale bytes array" do
    u64_69 = Scale::Types::U64.new([69, 0, 0, 0, 0, 0, 0, 0])
    expect(u64_69.value).to eql(69)
    expect(u64_69.bytes).to eql([69, 0, 0, 0, 0, 0, 0, 0])
    expect(u64_69.to_hex).to eql('0x4500000000000000')
    expect(u64_69.to_bin).to eql('0b0100010100000000000000000000000000000000000000000000000000000000')

  end

  it "can create from scale hex string" do
    u64_69 = Scale::Types::U64.new('0x4500000000000000')
    expect(u64_69.value).to eql(69)
    expect(u64_69.bytes).to eql([69, 0, 0, 0, 0, 0, 0, 0])
    expect(u64_69.to_hex).to eql('0x4500000000000000')
    expect(u64_69.to_bin).to eql('0b0100010100000000000000000000000000000000000000000000000000000000')
  end

  it "can create from encoding a integer" do
    u64_69 = 69.to_u64
    expect(u64_69.value).to eql(69)
    expect(u64_69.bytes).to eql([69, 0, 0, 0, 0, 0, 0, 0])
    expect(u64_69.to_hex).to eql('0x4500000000000000')
    expect(u64_69.to_bin).to eql('0b0100010100000000000000000000000000000000000000000000000000000000')
  end
end

describe Scale::Types::CompactU8 do
  it "can create from scale bytes array" do 
    a = Scale::Types::CompactU8.new([4])
    expect(a.value).to eql(1)

    b = 1.to_compact_u8
    expect(b.value).to eql(1)
    expect(b.bytes).to eql([4])
  end
end

describe Scale::Types::Student do
  it "can create from scale bytes array" do
    s = Scale::Types::Student.new([1, 0, 0, 0, 69, 0, 0, 0])
    expect(s.bytes).to eql([1, 0, 0, 0, 69, 0, 0, 0])
    expect(s.to_hex).to eql("0x0100000045000000")
    expect(s.age.value).to eql(1)
    expect(s.grade.value).to eql(69)

    expect(Scale::Types::Student::BYTES_LENGTH).to eql(8)
  end

  it "can create from scale hex string" do
    s = Scale::Types::Student.new("0x0100000045000000")
    expect(s.bytes).to eql([1, 0, 0, 0, 69, 0, 0, 0])
    expect(s.to_hex).to eql("0x0100000045000000")
    expect(s.age.value).to eql(1)
    expect(s.grade.value).to eql(69)
  end

  it "can create from scale types" do
    s = Scale::Types::Student.new(1.to_u32, 69.to_u32)
    expect(s.bytes).to eql([1, 0, 0, 0, 69, 0, 0, 0])
    expect(s.to_hex).to eql("0x0100000045000000")
    expect(s.age.value).to eql(1)
    expect(s.grade.value).to eql(69)
  end
end

describe Scale::Types::SomeU32 do
  it "can create from scale hex string" do
    o = Scale::Types::SomeU32.new("0x0145000000")

    expect(Scale::Types::SomeU32::VALUE_TYPE).to eql(Scale::Types::U32)
    expect(Scale::Types::SomeU32::BYTES_LENGTH).to eql(5)
    expect(o.value.value) == 69
  end

  it "can create from scale type" do
    o = Scale::Types::SomeU32.new(69.to_u32)

    expect(Scale::Types::SomeU32::VALUE_TYPE).to eql(Scale::Types::U32)
    expect(Scale::Types::SomeU32::BYTES_LENGTH).to eql(5)
    expect(o.value.value) == 69
  end
end

describe Scale::Types::None do
  it "eqls with 0x00" do
    o = Scale::Types::None.new("0x00")
    expect(o.to_hex).to eql("0x00")
    expect(o.bytes).to eql([0])
  end
end

describe Scale::Types::SomeBool do
  it "can create from scale hex string" do
    o = Scale::Types::SomeBool.new("0x01")
    expect(o.value.value).to eql(false)
    expect(o.bytes).to eql([1])
    expect(o.value.bytes).to eql([0])

    o2 = Scale::Types::SomeBool.new("0x02")
    expect(o2.value.value).to eql(true)
    expect(o2.bytes).to eql([2])
    expect(o2.value.bytes).to eql([1])
  end
end

#describe Scale::Types::IntOrBool do
#  it "xxx" do
#    expect(Scale::Types::IntOrBool::Int.new("0x002a").to_hex).to eql("0x002a")
#    expect(Scale::Types::IntOrBool::Int.new("0x002a").inner.value).to eql(42)
#    expect(Scale::Types::IntOrBool::Bool.new("0x0101").to_hex).to eql("0x0101")
#    expect(Scale::Types::IntOrBool::Bool.new("0x0101").inner.value).to eql(true)
#    expect(Scale::Types::IntOrBool::Int::BYTES_LENGTH).to eql(2)
#    expect(Scale::Types::IntOrBool::Bool::BYTES_LENGTH).to eql(2)
#  end
#end
# describe Scale::Types::Compact do
#   it "can create from scale bytes array" do 
#     bytes_a = [4] # 1
#     bytes_b = [21, 1] # 69
#     bytes_c = [2, 0, 1, 0] # 16384
# 
#     compact_a = Scale::Types::Compact.new(bytes_a)
#     compact_b = Scale::Types::Compact.new(bytes_b)
#     compact_c = Scale::Types::Compact.new(bytes_c)
#     expect(compact_a.value).to eql(1)
#     expect(compact_b.value).to eql(69)
#     expect(compact_c.value).to eql(16384)
#   end
# 
#   it "can create from encoding a integer" do
#     compact_a = 1.to_compact
#     compact_b = 69.to_compact
#     compact_c = 16384.to_compact
# 
#     expect(compact_a.value).to eql(1)
#     expect(compact_a.bytes).to eql([4])
#     expect(compact_b.value).to eql(69)
#     expect(compact_b.bytes).to eql([21, 1])
#     expect(compact_c.value).to eql(16384)
#     expect(compact_c.bytes).to eql([2, 0, 1, 0])
#   end
# end

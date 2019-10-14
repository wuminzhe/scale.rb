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

describe Scale::Types::Compact do
  it "can create from scale bytes array" do 
    bytes_a = [4] # 1
    bytes_b = [21, 1] # 69
    bytes_c = [2, 0, 1, 0] # 16384

    compact_a = Scale::Types::Compact.new(bytes_a)
    compact_b = Scale::Types::Compact.new(bytes_b)
    compact_c = Scale::Types::Compact.new(bytes_c)
    expect(compact_a.value).to eql(1)
    expect(compact_b.value).to eql(69)
    expect(compact_c.value).to eql(16384)
  end

  it "can create from encoding a integer" do
    compact_a = 1.to_compact
    compact_b = 69.to_compact
    compact_c = 16384.to_compact

    expect(compact_a.value).to eql(1)
    expect(compact_a.bytes).to eql([4])
    expect(compact_b.value).to eql(69)
    expect(compact_b.bytes).to eql([21, 1])
    expect(compact_c.value).to eql(16384)
    expect(compact_c.bytes).to eql([2, 0, 1, 0])
  end
end

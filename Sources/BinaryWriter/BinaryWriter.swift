
public struct BinaryWriter: ~Copyable {
    
    @usableFromInline
    var bytes: [UInt8]
    
    public consuming func end() -> [UInt8] {
        return bytes
    }
    
    public init() {
        self.bytes = []
    }
    
    public mutating func write(uint8: UInt8) {
        self.bytes.append(uint8)
    }
    
    public mutating func write(int8: Int8) {
        self.bytes.append(UInt8(bitPattern: int8))
    }
    
    public mutating func write(uint16: UInt16) {
        let low = UInt8(uint16 & 0xFF)
        let high = UInt8((uint16 >> 8) & 0xFF)
        self.bytes.append(low)
        self.bytes.append(high)
    }
    
    public mutating func write(int16: Int16) {
        write(uint16: UInt16(bitPattern: int16))
    }
    
    public mutating func write(uint32: UInt32) {
        let byte0 = UInt8(uint32 & 0xFF)
        let byte1 = UInt8((uint32 >> 8) & 0xFF)
        let byte2 = UInt8((uint32 >> 16) & 0xFF)
        let byte3 = UInt8((uint32 >> 24) & 0xFF)
        self.bytes.append(byte0)
        self.bytes.append(byte1)
        self.bytes.append(byte2)
        self.bytes.append(byte3)
    }
    
    public mutating func write(int32: Int32) {
        write(uint32: UInt32(bitPattern: int32))
    }
    
    public mutating func write(uint64: UInt64) {
        let byte0 = UInt8(uint64 & 0xFF)
        let byte1 = UInt8((uint64 >> 8) & 0xFF)
        let byte2 = UInt8((uint64 >> 16) & 0xFF)
        let byte3 = UInt8((uint64 >> 24) & 0xFF)
        let byte4 = UInt8((uint64 >> 32) & 0xFF)
        let byte5 = UInt8((uint64 >> 40) & 0xFF)
        let byte6 = UInt8((uint64 >> 48) & 0xFF)
        let byte7 = UInt8((uint64 >> 56) & 0xFF)
        self.bytes.append(byte0)
        self.bytes.append(byte1)
        self.bytes.append(byte2)
        self.bytes.append(byte3)
        self.bytes.append(byte4)
        self.bytes.append(byte5)
        self.bytes.append(byte6)
        self.bytes.append(byte7)
    }
    
    public mutating func write(int64: Int64) {
        write(uint64: UInt64(bitPattern: int64))
    }
    
    public mutating func write<S: StringProtocol>(fixedLengthString: S, assertingUTF8Count utf8Count: Int? = nil) {
        assert(utf8Count == nil || fixedLengthString.utf8.count == utf8Count)
        self.bytes.append(contentsOf: fixedLengthString.utf8)
    }
    
    public mutating func write(nullTerminatedString: String) {
        self.bytes.append(contentsOf: nullTerminatedString.utf8)
        self.bytes.append(0)
    }
}

import Foundation

public struct BinaryReader: ~Copyable {
    
    @usableFromInline
    let bytes: [UInt8]
    
    @usableFromInline
    var index: Int
    
    public init(decoding bytes: [UInt8]) {
        self.bytes = bytes
        self.index = 0
    }

    public borrowing func isEnd() -> Bool {
        return index >= bytes.count
    }
    
    public mutating func skip(byteCount: Int) -> Bool {
        guard byteCount >= 0 else { return false }
        guard index + byteCount <= bytes.count else { return false }
        index += byteCount
        return true
    }
    
    public mutating func readUInt8() -> UInt8? {
        guard isEnd() == false else { return nil }
        defer { index += 1 }
        return bytes[index]
    }
    
    public mutating func readInt8() -> Int8? {
        guard isEnd() == false else { return nil }
        defer { index += 1 }
        return Int8(bitPattern: bytes[index])
    }
    
    public mutating func readUInt16() -> UInt16? {
        guard index + 1 < bytes.count else { return nil }
        let low = UInt16(bytes[index])
        let high = UInt16(bytes[index + 1])
        index += 2
        return low | (high << 8)
    }
    
    public mutating func readInt16() -> Int16? {
        guard let uint16 = readUInt16() else { return nil }
        return Int16(bitPattern: uint16)
    }
    
    public mutating func readUInt32() -> UInt32? {
        guard index + 3 < bytes.count else { return nil }
        let byte0 = UInt32(bytes[index])
        let byte1 = UInt32(bytes[index + 1])
        let byte2 = UInt32(bytes[index + 2])
        let byte3 = UInt32(bytes[index + 3])
        index += 4
        return byte0 | (byte1 << 8) | (byte2 << 16) | (byte3 << 24)
    }
    
    public mutating func readInt32() -> Int32? {
        guard let uint32 = readUInt32() else { return nil }
        return Int32(bitPattern: uint32)
    }
    
    public mutating func readUInt64() -> UInt64? {
        guard index + 7 < bytes.count else { return nil }
        let byte0 = UInt64(bytes[index])
        let byte1 = UInt64(bytes[index + 1])
        let byte2 = UInt64(bytes[index + 2])
        let byte3 = UInt64(bytes[index + 3])
        let byte4 = UInt64(bytes[index + 4])
        let byte5 = UInt64(bytes[index + 5])
        let byte6 = UInt64(bytes[index + 6])
        let byte7 = UInt64(bytes[index + 7])
        index += 8
        return byte0 | (byte1 << 8) | (byte2 << 16) | (byte3 << 24) | 
               (byte4 << 32) | (byte5 << 40) | (byte6 << 48) | (byte7 << 56)
    }
    
    public mutating func readInt64() -> Int64? {
        guard let uint64 = readUInt64() else { return nil }
        return Int64(bitPattern: uint64)
    }
    
    public mutating func readFixedLengthString(utf8Count: Int) -> String? {
        guard utf8Count >= 0 else { return nil }
        guard index + utf8Count <= bytes.count else { return nil }
        let stringBytes = Array(bytes[index..<index + utf8Count])
        index += utf8Count
        return String(bytes: stringBytes, encoding: .utf8)
    }
    
    public mutating func readNullTerminatedString() -> String? {
        // Find the null terminator
        var nullIndex = index
        while nullIndex < bytes.count && bytes[nullIndex] != 0 {
            nullIndex += 1
        }
        
        // If we didn't find a null terminator, return nil
        guard nullIndex < bytes.count else { return nil }
        
        // Extract the string bytes (excluding the null terminator)
        let stringBytes = Array(bytes[index..<nullIndex])
        index = nullIndex + 1 // Skip the null terminator
        
        return String(bytes: stringBytes, encoding: .utf8)
    }
}

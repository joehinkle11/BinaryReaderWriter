import Testing
import BinaryWriter
import BinaryReader

@Test func `empty`() {
    let writer = BinaryWriter()
    let bytes = writer.end()
    #expect(bytes.isEmpty)
    
    let reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == true)
}

@Test func `ints`() {
    var writer = BinaryWriter()
    var expectedCount = 0
    writer.write(uint8: 5); expectedCount += 1
    writer.write(int8: -5); expectedCount += 1
    writer.write(uint16: 345); expectedCount += 2
    writer.write(int16: -345); expectedCount += 2
    writer.write(uint32: 123456); expectedCount += 4
    writer.write(int32: -123456); expectedCount += 4
    writer.write(uint64: 9876543210); expectedCount += 8
    writer.write(int64: -9876543210); expectedCount += 8
    let bytes = writer.end()
    #expect(bytes.count == expectedCount)
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == false)
    #expect(reader.readUInt8() == 5)
    #expect(reader.readInt8() == -5)
    #expect(reader.readUInt16() == 345)
    #expect(reader.readInt16() == -345)
    #expect(reader.readUInt32() == 123456)
    #expect(reader.readInt32() == -123456)
    #expect(reader.readUInt64() == 9876543210)
    #expect(reader.readInt64() == -9876543210)
    #expect(reader.isEnd() == true)
}

@Test func `skip`() {
    var writer = BinaryWriter()
    writer.write(uint8: 10)
    writer.write(uint8: 20)
    writer.write(uint8: 30)
    writer.write(uint8: 40)
    writer.write(uint8: 50)
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == false)
    
    // Skip 2 bytes
    #expect(reader.skip(byteCount: 2) == true)
    #expect(reader.readUInt8() == 30)
    
    // Skip 1 byte
    #expect(reader.skip(byteCount: 1) == true)
    #expect(reader.readUInt8() == 50)
    
    // Try to skip beyond end
    #expect(reader.skip(byteCount: 1) == false)
    #expect(reader.isEnd() == true)
    
    // Try negative skip
    var reader2 = BinaryReader(decoding: bytes)
    #expect(reader2.skip(byteCount: -1) == false)
    
    // Skip exact remaining bytes
    var reader3 = BinaryReader(decoding: bytes)
    #expect(reader3.skip(byteCount: 5) == true)
    #expect(reader3.isEnd() == true)
}

@Test func `staticString`() {
    var writer = BinaryWriter()
    let testString = "Hello"
    writer.write(fixedLengthString: testString)
    let bytes = writer.end()
    #expect(bytes.count == testString.utf8.count)
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == false)
    let decoded = reader.readFixedLengthString(utf8Count: testString.utf8.count)
    #expect(decoded == testString)
    #expect(reader.isEnd() == true)
}

@Test func `staticString_empty`() {
    var writer = BinaryWriter()
    let testString = ""
    writer.write(fixedLengthString: testString)
    let bytes = writer.end()
    #expect(bytes.count == 0)
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == true)
    let decoded = reader.readFixedLengthString(utf8Count: 0)
    #expect(decoded == "")
}

@Test func `staticString_withSpecialCharacters`() {
    var writer = BinaryWriter()
    let testString = "Hello, 世界! 🌍"
    writer.write(fixedLengthString: testString)
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    let decoded = reader.readFixedLengthString(utf8Count: testString.utf8.count)
    #expect(decoded == testString)
}

@Test func `staticString_multipleStrings`() {
    var writer = BinaryWriter()
    let str1 = "Hello"
    let str2 = "World"
    writer.write(fixedLengthString: str1)
    writer.write(fixedLengthString: str2)
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.readFixedLengthString(utf8Count: str1.utf8.count) == str1)
    #expect(reader.readFixedLengthString(utf8Count: str2.utf8.count) == str2)
    #expect(reader.isEnd() == true)
}

@Test func `staticString_wrongCount`() {
    var writer = BinaryWriter()
    writer.write(fixedLengthString: "Hello")
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    // Try to read with wrong count (too large)
    #expect(reader.readFixedLengthString(utf8Count: 100) == nil)
    
    var reader2 = BinaryReader(decoding: bytes)
    // Try to read with wrong count (too small)
    let partial = reader2.readFixedLengthString(utf8Count: 2)
    #expect(partial != "Hello")
}

@Test func `staticString_negativeCount`() {
    var writer = BinaryWriter()
    writer.write(fixedLengthString: "Hello")
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.readFixedLengthString(utf8Count: -1) == nil)
}

@Test func `nullTerminatedString`() {
    var writer = BinaryWriter()
    let testString = "Hello"
    writer.write(nullTerminatedString: testString)
    let bytes = writer.end()
    #expect(bytes.count == testString.utf8.count + 1) // +1 for null terminator
    #expect(bytes.last == 0) // Last byte should be null terminator
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == false)
    let decoded = reader.readNullTerminatedString()
    #expect(decoded == testString)
    #expect(reader.isEnd() == true)
}

@Test func `nullTerminatedString_empty`() {
    var writer = BinaryWriter()
    let testString = ""
    writer.write(nullTerminatedString: testString)
    let bytes = writer.end()
    #expect(bytes.count == 1) // Just the null terminator
    #expect(bytes[0] == 0)
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.isEnd() == false)
    let decoded = reader.readNullTerminatedString()
    #expect(decoded == "")
    #expect(reader.isEnd() == true)
}

@Test func `nullTerminatedString_withSpecialCharacters`() {
    var writer = BinaryWriter()
    let testString = "Hello, 世界! 🌍"
    writer.write(nullTerminatedString: testString)
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    let decoded = reader.readNullTerminatedString()
    #expect(decoded == testString)
    #expect(reader.isEnd() == true)
}

@Test func `nullTerminatedString_multipleStrings`() {
    var writer = BinaryWriter()
    let str1 = "Hello"
    let str2 = "World"
    writer.write(nullTerminatedString: str1)
    writer.write(nullTerminatedString: str2)
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    #expect(reader.readNullTerminatedString() == str1)
    #expect(reader.readNullTerminatedString() == str2)
    #expect(reader.isEnd() == true)
}

@Test func `nullTerminatedString_noTerminator`() {
    var writer = BinaryWriter()
    writer.write(fixedLengthString: "Hello") // Write without null terminator
    let bytes = writer.end()
    
    var reader = BinaryReader(decoding: bytes)
    // Should return nil when no null terminator is found
    #expect(reader.readNullTerminatedString() == nil)
    // Index should not have advanced
    #expect(reader.isEnd() == false)
}

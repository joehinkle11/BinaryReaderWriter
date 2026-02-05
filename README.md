# BinaryReaderWriter

Swift package for sequential binary reading and writing. Little-endian byte order.

## Products

- **BinaryReader** — Read primitive types (UInt8, Int16, UInt32, etc.) from a byte buffer with a moving cursor.
- **BinaryWriter** — Append primitive types to a buffer; call `end()` to get the resulting `[UInt8]`.

## Requirements

Swift 6.2+

## Usage

```swift
// Swift Package Manager
.package(url: "https://github.com/your-org/BinaryReaderWriter.git", from: "0.1.0")
```

Add `BinaryReader` and/or `BinaryWriter` to your target dependencies.


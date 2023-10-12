//
//  File.swift
//  
//
//  Created by Ravil Khusainov on 23.08.23.
//

import Foundation
import Fluent
import FluentPostgresDriver

extension Point: PostgresNonThrowingEncodable {
    public static var psqlType: PostgresDataType { .text }
    public static var psqlFormat: PostgresFormat { .binary }
    
    public func encode<JSONEncoder>(into byteBuffer: inout ByteBuffer, context: PostgresEncodingContext<JSONEncoder>) where JSONEncoder : PostgresJSONEncoder {
        let string = "POINT(\(x) \(y))"
        byteBuffer.writeString(string)
    }
}

extension Point: PostgresDecodable {
    public init<JSONDecoder>(from byteBuffer: inout ByteBuffer, type: PostgresDataType, format: PostgresFormat, context: PostgresDecodingContext<JSONDecoder>) throws where JSONDecoder : PostgresJSONDecoder {
        
        guard let endianByte: UInt8 = byteBuffer.readInteger(), endianByte == 1 else {
            throw DecodingError.wrongDataFormat
        }
        
        // Skipping type and SRID bytes, assuming we know we're dealing with POINT and SRID=4326
        byteBuffer.moveReaderIndex(forwardBy: 8)
        
        guard let x = byteBuffer.readDouble(), let y = byteBuffer.readDouble() else {
            throw DecodingError.wrongDataFormat
        }
        
        self.init(x: x, y: y)
    }
}

extension ByteBuffer {
    mutating func readDouble() -> Double? {
        guard let bits: UInt64 = readInteger() else { return nil }
        let data = withUnsafeBytes(of: bits) { Data($0) }
        let reversedData = Data(data.reversed())
        let correctBitPattern = reversedData.withUnsafeBytes { $0.load(as: Int64.self) }
        return Double(bitPattern: UInt64(bitPattern: correctBitPattern))
    }
}


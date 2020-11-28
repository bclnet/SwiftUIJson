//
//  Codable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension KeyedEncodingContainer where K : CodingKey {
    public mutating func encodeKey(forKey key: KeyedEncodingContainer<K>.Key) throws {
        try encode("1", forKey: key)
    }
    public mutating func encodeOptional<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T : Encodable {
        try encode(value, forKey: key)
    }
}

extension KeyedDecodingContainer where K : CodingKey {
    public func decodeKey<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable {
        try decode(type, forKey: key)
    }

    public func decodeKeyIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        try decodeIfPresent(type, forKey: key)
    }
}

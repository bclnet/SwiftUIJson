//
//  JsonCodeable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension KeyedDecodingContainer where K : CodingKey {

    public func decodeOptional<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, forContext context: JsonContext) throws -> T? where T : Decodable {
        try decode(type, forKey: key, forContext: context)
    }

    public func decodeOptionalIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, forContext context: JsonContext) throws -> T? where T : Decodable {
        try decodeIfPresent(type, forKey: key, forContext: context)
    }
}

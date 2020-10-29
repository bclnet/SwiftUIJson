//
//  _EnvironmentKeyWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _EnvironmentKeyWritingModifier<Value>: DynaConvertedCodable {
    let value: Value
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    public init(any: Any) {
        let m = Mirror.children(reflecting: any)
        value = m["value"]! as! Value
        keyPath = m["keyPath"]! as! WritableKeyPath<EnvironmentValues, Value>
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case value, keyPath
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        fatalError()
//        value = try container.decodeIfPresent(Value.self, forKey: .value)
//        keyPath = try container.decodeAny(WritableKeyPath<EnvironmentValues, Value?>.self, forKey: .keyPath)
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(value, forKey: .value)
//        try container.encodeAny(keyPath, forKey: .keyPath)
    }
    //: Register
    static func register() {
        // MARK: - Autocorrection:17266
        DynaType.register(_EnvironmentKeyWritingModifier<Any?>.self, any: [Any?.self], namespace: "SwiftUI")
//        DynaType.registerFactory(any: [Any?.self], namespace: "SwiftUI") { (t: Any) in
//            func factory<T>(t: T) -> Any.Type { _EnvironmentKeyWritingModifier<T.Type>.self }
//            return factory(t: t)
//        }
    }
}

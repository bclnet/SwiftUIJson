//
//  _EnvironmentKeyWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _EnvironmentKeyWritingModifier<Value>: JsonViewModifier, ConvertibleCodable where Value : Codable {
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    let value: Value
    public init(any: Any) {
        Mirror.assert(any, name: "_EnvironmentKeyWritingModifier", keys: ["keyPath", "value"])
        let m = Mirror.children(reflecting: any)
        keyPath = m["keyPath"]! as! WritableKeyPath<EnvironmentValues, Value>
        value = m["value"]! as! Value
    }
    func body(content: AnyView) -> AnyView { AnyView(content.environment(keyPath, value)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case keyPath, key, value
    }
    public func encode(to encoder: Encoder) throws {
        val action = EnvironmentValues.find(keyPath: keyPath)!
        val key = PType.typeKey(type: keyPath)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .keyPath)
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let action = try container.decode(String.self, forKey: .keyPath)
        let getKeyPath: (() -> WritableKeyPath<EnvironmentValues, Value>) = PType.find(action: action, forKey: try container.decode(String.self, forKey: .key))!
        keyPath = getKeyPath()
        value = try container.decode(Value.self, forKey: .value)
    }

    //: Register
    static func register() {
        PType.register(_EnvironmentKeyWritingModifier<Bool?>.self, any: [Bool?.self], namespace: "SwiftUI")
        PType.register(_EnvironmentKeyWritingModifier<Color?>.self, any: [Color?.self], namespace: "SwiftUI")
    }
}

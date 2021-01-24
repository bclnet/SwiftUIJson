//
//  _EnvironmentKeyWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _EnvironmentKeyWritingModifier<Value>: JsonViewModifier, ConvertibleCodable where Value : Codable {
    let value: Value
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    let action: String
    public init(any: Any) {
        Mirror.assert(any, name: "_EnvironmentKeyWritingModifier", keys: ["value", "keyPath"])
        let m = Mirror.children(reflecting: any)
        value = m["value"]! as! Value
        keyPath = m["keyPath"]! as! WritableKeyPath<EnvironmentValues, Value>
        action = EnvironmentValues.find(keyPath: keyPath)!
    }
    func body(content: AnyView) -> AnyView { AnyView(content.environment(keyPath, value)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case action, value, keyPath
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(value, forKey: .value)
        try container.encode(PType.typeKey(type: keyPath), forKey: .keyPath)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(String.self, forKey: .action)
        value = try container.decode(Value.self, forKey: .value)
        let getKeyPath: (() -> WritableKeyPath<EnvironmentValues, Value>) = PType.find(action: action, forKey: try container.decode(String.self, forKey: .keyPath))!
        keyPath = getKeyPath()
    }

    //: Register
    static func register() {
        PType.register(_EnvironmentKeyWritingModifier<Bool?>.self, any: [Bool?.self], namespace: "SwiftUI")
        PType.register(_EnvironmentKeyWritingModifier<Color?>.self, any: [Color?.self], namespace: "SwiftUI")
    }
}

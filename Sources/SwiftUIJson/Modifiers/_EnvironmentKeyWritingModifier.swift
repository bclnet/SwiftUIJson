//
//  _EnvironmentKeyWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _EnvironmentKeyWritingModifier<Value>: JsonViewModifier, DynaConvertedCodable where Value : Codable {
    let action: String
    let value: Value
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    public init(any: Any) {
        let m = Mirror.children(reflecting: any)
        value = m["value"]! as! Value
        keyPath = m["keyPath"]! as! WritableKeyPath<EnvironmentValues, Value>
        action = EnvironmentValues.find(keyPath: keyPath)!
    }
    //: JsonViewModifier
    func body(content: AnyView) -> AnyView {
        return AnyView(content.environment(keyPath, value))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case action, value, keyPath
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(String.self, forKey: .action)
        value = try container.decode(Value.self, forKey: .value)
        keyPath = (DynaType.find(action: action, forKey: try container.decode(String.self, forKey: .keyPath)) as! (() -> WritableKeyPath<EnvironmentValues, Value>))()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(value, forKey: .value)
        try container.encode(DynaType.typeKey(type: keyPath), forKey: .keyPath)
    }
    //: Register
    static func register() {
        // MARK: - Autocorrection:17266
        DynaType.register(_EnvironmentKeyWritingModifier<Bool?>.self, any: [Bool?.self], namespace: "SwiftUI")
    }
}

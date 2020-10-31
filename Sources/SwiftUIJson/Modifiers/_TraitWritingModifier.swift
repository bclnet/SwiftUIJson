//
//  _TraitWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _TraitWritingModifier<TraitKey>: JsonViewModifier, DynaConvertedCodable where TraitKey : Codable {
    let value: Any
    public init(any: Any) {
        value = Mirror(reflecting: any).descendant("value")!
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        fatalError()
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case value
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        (datePickerStyle, style) = try DynaType.find(actionAndType: "datePickerStyle", forKey: try container.decode(String.self, forKey: .value))
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(DynaType.typeKey(type: style), forKey: .value)
    }
    //: Register
    static func register() {
        DynaType.register(_TraitWritingModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(ItemProviderTraitKey.self, namespace: "SwiftUI")
    }
}
protocol AnyTraitKey {
    func doit()
}

struct ItemProviderTraitKey: Codable {
    func doit() {
//        as? (() -> NSItemProvider?)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
    }
}

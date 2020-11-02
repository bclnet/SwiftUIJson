//
//  _TraitWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

fileprivate protocol AnyTraitKey: JsonViewModifier {}

struct _TraitWritingModifier<TraitKey>: JsonViewModifier, DynaConvertedCodable where TraitKey : Codable {
    let valueKey: String
    let value: Any
    public init(any: Any) {
        valueKey = DynaType.typeKey(type: any)
        value = Mirror(reflecting: any).descendant("value")!
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        (value as! AnyTraitKey).body(content: content)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case isDeleteDisabled, isMoveDisabled, itemProvider
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var traitKey: AnyTraitKey!
        for key in container.allKeys {
            switch key {
            case .isDeleteDisabled: traitKey = try container.decode(IsDeleteDisabledTraitKey.self, forKey: key)
            case .isMoveDisabled: traitKey = try container.decode(IsMoveDisabledTraitKey.self, forKey: key)
            case .itemProvider: traitKey = try container.decode(ItemProviderTraitKey.self, forKey: key)
            }
        }
        valueKey = ""
        value = traitKey! as Any
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch valueKey {
        case ":_TraitWritingModifier<:IsDeleteDisabledTraitKey>": try container.encode(IsDeleteDisabledTraitKey(any: value), forKey: .isDeleteDisabled)
        case ":_TraitWritingModifier<:IsMoveDisabledTraitKey>": try container.encode(IsMoveDisabledTraitKey(any: value), forKey: .isMoveDisabled)
        case ":_TraitWritingModifier<:ItemProviderTraitKey>": try container.encode(ItemProviderTraitKey(any: value), forKey: .itemProvider)
        default: fatalError(valueKey)
        }
    }
    //: Register
    static func register() {
        DynaType.register(_TraitWritingModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(IsDeleteDisabledTraitKey.self, namespace: "SwiftUI")
        DynaType.register(IsMoveDisabledTraitKey.self, namespace: "SwiftUI")
        DynaType.register(ItemProviderTraitKey.self, namespace: "SwiftUI")
    }
}

struct IsDeleteDisabledTraitKey: AnyTraitKey, Codable {
    let value: Bool
    init(any s: Any) {
        value = s as! Bool
    }
    func body(content: AnyView) -> AnyView {
        AnyView(content.deleteDisabled(value))
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Bool.self)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct IsMoveDisabledTraitKey: AnyTraitKey, Codable {
    let value: Bool
    init(any s: Any) {
        value = s as! Bool
    }
    func body(content: AnyView) -> AnyView {
        AnyView(content.moveDisabled(value))
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Bool.self)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct ItemProviderTraitKey: AnyTraitKey, Codable {
    let value: (() -> NSItemProvider?)
    init(any s: Any) {
        value = s as! (() -> NSItemProvider?)
    }
    func body(content: AnyView) -> AnyView {
        AnyView(content.itemProvider(value))
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = { nil }
            return
        }
        let item = try NSItemProvider.decode(from: decoder)
        value = { item }
    }
    public func encode(to encoder: Encoder) throws {
        let item = value()
        var container = encoder.singleValueContainer()
        if item == nil {
            try container.encodeNil()
            return
        }
        try item!.encode(to: encoder)
    }
}

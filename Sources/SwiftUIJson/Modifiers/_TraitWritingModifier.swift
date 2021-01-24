//
//  _TraitWritingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

protocol AnyTraitKey: JsonViewModifier {}

struct _TraitWritingModifier<TraitKey>: JsonViewModifier, ConvertibleCodable where TraitKey : Codable {
    let valueKey: String
    let value: Any
    public init(any: Any) {
        Mirror.assert(any, name: "_TraitWritingModifier", keys: ["value"])
        valueKey = PType.typeKey(type: any)
        value = Mirror(reflecting: any).descendant("value")!
    }

    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { (value as! AnyTraitKey).body(content: content) }

    //: Codable
    enum CodingKeys: CodingKey {
        case isDeleteDisabled, isMoveDisabled, itemProvider, previewLayout, zIndex
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch valueKey {
        case ":_TraitWritingModifier<:IsDeleteDisabledTraitKey>": try container.encode(IsDeleteDisabledTraitKey(any: value), forKey: .isDeleteDisabled)
        case ":_TraitWritingModifier<:IsMoveDisabledTraitKey>": try container.encode(IsMoveDisabledTraitKey(any: value), forKey: .isMoveDisabled)
        case ":_TraitWritingModifier<:ItemProviderTraitKey>": try container.encode(ItemProviderTraitKey(any: value), forKey: .itemProvider)
        case ":_TraitWritingModifier<:PreviewLayoutTraitKey>": try container.encode(PreviewLayoutTraitKey(any: value), forKey: .previewLayout)
        case ":_TraitWritingModifier<:ZIndexTraitKey>": try container.encode(ZIndexTraitKey(any: value), forKey: .zIndex)
        case let value: fatalError(value)
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var traitKey: AnyTraitKey!
        for key in container.allKeys {
            switch key {
            case .isDeleteDisabled: traitKey = try container.decode(IsDeleteDisabledTraitKey.self, forKey: key)
            case .isMoveDisabled: traitKey = try container.decode(IsMoveDisabledTraitKey.self, forKey: key)
            case .itemProvider: traitKey = try container.decode(ItemProviderTraitKey.self, forKey: key)
            case .previewLayout: traitKey = try container.decode(PreviewLayoutTraitKey.self, forKey: key)
            case .zIndex: traitKey = try container.decode(ZIndexTraitKey.self, forKey: key)
            }
        }
        valueKey = ""
        value = traitKey! as Any
    }

    //: Register
    static func register() {
        PType.register(_TraitWritingModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(IsDeleteDisabledTraitKey.self, namespace: "SwiftUI")
        PType.register(IsMoveDisabledTraitKey.self, namespace: "SwiftUI")
        PType.register(ItemProviderTraitKey.self, namespace: "SwiftUI")
        PType.register(PreviewLayoutTraitKey.self, namespace: "SwiftUI")
        PType.register(ZIndexTraitKey.self, namespace: "SwiftUI")
    }
}

struct IsDeleteDisabledTraitKey: AnyTraitKey, Codable {
    let value: Bool
    init(any: Any) {
        value = any as! Bool
    }
    func body(content: AnyView) -> AnyView { AnyView(content.deleteDisabled(value)) }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Bool.self)
    }
}

struct IsMoveDisabledTraitKey: AnyTraitKey, Codable {
    let value: Bool
    init(any: Any) {
        value = any as! Bool
    }
    func body(content: AnyView) -> AnyView { AnyView(content.moveDisabled(value)) }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Bool.self)
    }
}

struct ItemProviderTraitKey: AnyTraitKey, Codable {
    let value: (() -> NSItemProvider?)
    init(any: Any) {
        value = any as! (() -> NSItemProvider?)
    }
    func body(content: AnyView) -> AnyView { AnyView(content.itemProvider(value)) }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        let item = value()
        var container = encoder.singleValueContainer()
        if item == nil {
            try container.encodeNil()
            return
        }
        try item!.encode(to: encoder)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = { nil }
            return
        }
        let item = try NSItemProvider.decode(from: decoder)
        value = { item }
    }
}

struct PreviewLayoutTraitKey: AnyTraitKey, Codable {
    let value: PreviewLayout
    init(any: Any) {
        value = any as! PreviewLayout
    }
    func body(content: AnyView) -> AnyView { AnyView(content.previewLayout(value)) }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(PreviewLayout.self)
    }
}

struct ZIndexTraitKey: AnyTraitKey, Codable {
    let value: Double
    init(any: Any) {
        value = any as! Double
    }
    func body(content: AnyView) -> AnyView { AnyView(content.zIndex(value)) }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Double.self)
    }
}

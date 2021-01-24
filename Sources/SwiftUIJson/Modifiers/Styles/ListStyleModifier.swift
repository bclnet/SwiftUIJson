//
//  ListStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct ListStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "ListStyleModifier", keys: ["style"])
        style = Mirror(reflecting: any).descendant("style")!
        action = nil
    }

    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { action(AnyView(content)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = PType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        (action, style) = try PType.find(actionAndType: "style", forKey: styleKey)
    }

    //: Register
    static func register() {
        PType.register(ListStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(DefaultListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(DefaultListStyle())) }])
        #if !os(macOS) && !os(watchOS)
        PType.register(GroupedListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(GroupedListStyle())) }])
        #endif
        #if !os(macOS) && !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, *) {
            PType.register(InsetGroupedListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(InsetGroupedListStyle())) }])
        }
        #endif
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 11.0, *) {
            PType.register(InsetListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(InsetListStyle())) }])
        }
        #endif
        PType.register(PlainListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(PlainListStyle())) }])
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 10.15, *) {
            PType.register(SidebarListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(SidebarListStyle())) }])
        }
        #endif
        #if os(watchOS)
        PType.register(CarouselListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(CarouselListStyle())) }])
        if #available(watchOS 7.0, *) {
            PType.register(EllipticalListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(EllipticalListStyle())) }])
        }
        #endif
    }
}

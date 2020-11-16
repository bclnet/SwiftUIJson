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
    public func body(content: AnyView) -> AnyView {
        action(AnyView(content))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        (action, style) = try DynaType.find(actionAndType: "style", forKey: styleKey)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = DynaType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(ListStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(DefaultListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(DefaultListStyle())) }])
        #if !os(macOS) && !os(watchOS)
        DynaType.register(GroupedListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(GroupedListStyle())) }])
        #endif
        #if !os(macOS) && !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, *) {
            DynaType.register(InsetGroupedListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(InsetGroupedListStyle())) }])
        }
        #endif
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 11.0, *) {
            DynaType.register(InsetListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(InsetListStyle())) }])
        }
        #endif
        DynaType.register(PlainListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(PlainListStyle())) }])
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 10.15, *) {
            DynaType.register(SidebarListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(SidebarListStyle())) }])
        }
        #endif
        #if os(watchOS)
        DynaType.register(CarouselListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(CarouselListStyle())) }])
        if #available(watchOS 7.0, *) {
            DynaType.register(EllipticalListStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.listStyle(EllipticalListStyle())) }])
        }
        #endif
    }
}

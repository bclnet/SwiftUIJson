//
//  _TabViewStyleWriter.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct _TabViewStyleWriter<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "_TabViewStyleWriter", keys: ["style"])
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
        (action, style) = try PType.find(actionAndType: "style", forKey: styleKey)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = PType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        PType.register(_TabViewStyleWriter<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(DefaultTabViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.tabViewStyle(DefaultTabViewStyle())) }])
        #if !os(macOS)
        PType.register(PageTabViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.tabViewStyle(PageTabViewStyle())) }])
        #endif
        #if os(watchOS)
        PType.register(CarouselTabViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.tabViewStyle(CarouselTabViewStyle())) }])
        #endif
    }
}

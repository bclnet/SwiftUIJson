//
//  ButtonStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct ButtonStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "ButtonStyleModifier", keys: ["style"])
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
        PType.register(ButtonStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        #if !os(iOS) &&  !os(watchOS)
        PType.register(BorderlessButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(BorderlessButtonStyle())) }])
        #endif
        PType.register(DefaultButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(DefaultButtonStyle())) }])
        PType.register(PlainButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(PlainButtonStyle())) }])
        #if !os(iOS)
        if #available(macOS 10.15, tvOS 13.0, watchOS 7.0, *) {
            PType.register(BorderedButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(BorderedButtonStyle())) }])
        }
        PType.register(LinkButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(LinkButtonStyle())) }])
        #endif
        #if os(tvOS)
        PType.register(CardButtonStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.buttonStyle(CardButtonStyle())) }])
        #endif
    }
}

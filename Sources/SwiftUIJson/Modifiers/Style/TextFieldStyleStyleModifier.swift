//
//  TextFieldStyleStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct TextFieldStyleStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "TextFieldStyleStyleModifier", keys: ["style"])
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
        PType.register(TextFieldStyleStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(DefaultTextFieldStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.textFieldStyle(DefaultTextFieldStyle())) }])
        PType.register(PlainTextFieldStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.textFieldStyle(PlainTextFieldStyle())) }])
        #if !os(tvOS) && !os(watchOS)
        PType.register(RoundedBorderTextFieldStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.textFieldStyle(RoundedBorderTextFieldStyle())) }])
        #endif
        #if !os(iOS) && !os(tvOS) && !os(watchOS)
        PType.register(SquareBorderTextFieldStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.textFieldStyle(SquareBorderTextFieldStyle())) }])
        #endif
    }
}

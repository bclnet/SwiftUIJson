//
//  LabelStyleStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct LabelStyleStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "LabelStyleStyleModifier", keys: ["style"])
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
        PType.register(LabelStyleStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(DefaultLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(DefaultLabelStyle())) }])
        PType.register(IconOnlyLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(IconOnlyLabelStyle())) }])
        PType.register(TitleOnlyLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(TitleOnlyLabelStyle())) }])
    }
}

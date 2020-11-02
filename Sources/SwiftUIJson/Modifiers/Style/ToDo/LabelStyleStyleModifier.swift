//
//  LabelStyleStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct LabelStyleStyleModifier<Style>: JsonViewModifier, DynaConvertedCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
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
        DynaType.register(LabelStyleStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(DefaultLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(DefaultLabelStyle())) }])
        DynaType.register(IconOnlyLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(IconOnlyLabelStyle())) }])
        DynaType.register(TitleOnlyLabelStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.labelStyle(TitleOnlyLabelStyle())) }])
    }
}

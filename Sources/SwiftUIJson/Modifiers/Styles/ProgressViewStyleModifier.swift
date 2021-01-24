//
//  ProgressViewStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct ProgressViewStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "ProgressViewStyleModifier", keys: ["style"])
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
        PType.register(ProgressViewStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(CircularProgressViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.progressViewStyle(CircularProgressViewStyle())) }])
        PType.register(DefaultProgressViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.progressViewStyle(DefaultProgressViewStyle())) }])
        PType.register(LinearProgressViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.progressViewStyle(LinearProgressViewStyle())) }])
    }
}

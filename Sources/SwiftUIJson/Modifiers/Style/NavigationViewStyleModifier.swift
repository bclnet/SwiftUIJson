//
//  NavigationViewStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct NavigationViewStyleModifier<Style>: JsonViewModifier, DynaConvertedCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "NavigationViewStyleModifier", keys: ["style"])
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
        DynaType.register(NavigationViewStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(DefaultNavigationViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.navigationViewStyle(DefaultNavigationViewStyle())) }])
        DynaType.register(DoubleColumnNavigationViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.navigationViewStyle(DoubleColumnNavigationViewStyle())) }])
        DynaType.register(StackNavigationViewStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.navigationViewStyle(StackNavigationViewStyle())) }])
    }
}

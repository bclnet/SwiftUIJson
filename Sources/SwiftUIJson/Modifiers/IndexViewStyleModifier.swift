//
//  IndexViewStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct IndexViewStyleModifier<Style>: JsonViewModifier, DynaConvertedCodable where Style: Codable {
    let style: Any
    let indexViewStyle: Any?
    public init(any: Any) {
        style = Mirror(reflecting: any).descendant("style")!
        indexViewStyle = nil
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        (indexViewStyle as! ((AnyView) -> AnyView))(AnyView(content))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        (indexViewStyle, style) = try DynaType.find(actionAndType: "indexViewStyle", forKey: styleKey)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = DynaType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(IndexViewStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(PageIndexViewStyle.self, actions: ["indexViewStyle": { (content: AnyView) in AnyView(content.indexViewStyle(PageIndexViewStyle())) }])
    }
}

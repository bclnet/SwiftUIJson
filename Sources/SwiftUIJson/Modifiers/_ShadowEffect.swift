//
//  _ShadowEffect.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _ShadowEffect: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case color, radius, offset
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color = try container.decode(Color.self, forKey: .color)
        let radius = try container.decode(CGFloat.self, forKey: .radius)
        let offset = try container.decode(CGSize.self, forKey: .offset)
        self.init(color: color, radius: radius, offset: offset)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_ShadowEffect", keys: ["color", "radius", "offset"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
        try container.encode(radius, forKey: .radius)
        try container.encode(offset, forKey: .offset)
    }
    //: Register
    static func register() {
        DynaType.register(_ShadowEffect.self)
    }
}

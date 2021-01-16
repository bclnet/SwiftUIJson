//
//  _RotationEffect.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _RotationEffect: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    //: Codable
    enum CodingKeys: CodingKey {
        case angle, anchor
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let angle = try container.decode(Angle.self, forKey: .angle)
        let anchor = try container.decode(UnitPoint.self, forKey: .anchor)
        self.init(angle: angle, anchor: anchor)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_RotationEffect", keys: ["angle", "anchor"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(angle, forKey: .angle)
        try container.encode(anchor, forKey: .anchor)
    }
    //: Register
    static func register() {
        PType.register(_RotationEffect.self)
    }
}

//
//  RadialGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension RadialGradient: IAnyView, FullyCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case gradient, center, startRadius, endRadius
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let center = try container.decode(UnitPoint.self, forKey: .center)
        let startRadius = try container.decode(CGFloat.self, forKey: .startRadius)
        let endRadius = try container.decode(CGFloat.self, forKey: .endRadius)
        self.init(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "RadialGradient", keys: ["gradient", "center", "startRadius", "endRadius"])
        let m = Mirror.children(reflecting: self)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(m["gradient"]! as! Gradient, forKey: .gradient)
        try container.encode(m["center"]! as! UnitPoint, forKey: .center)
        try container.encode(m["startRadius"]! as! CGFloat, forKey: .startRadius)
        try container.encode(m["endRadius"]! as! CGFloat, forKey: .endRadius)
    }
    //: Register
    static func register() {
        DynaType.register(RadialGradient.self)
    }
}

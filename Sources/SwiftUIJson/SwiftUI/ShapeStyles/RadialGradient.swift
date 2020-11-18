//
//  RadialGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension RadialGradient: FullyCodable {
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
//        let m = Mirror.children(reflecting: self)
        fatalError()
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(gradient, forKey: .gradient)
//        try container.encode(center, forKey: .center)
//        try container.encode(startRadius, forKey: .startRadius)
//        try container.encode(endRadius, forKey: .endRadius)
    }
    //: Register
    static func register() {
        DynaType.register(RadialGradient.self)
    }
}

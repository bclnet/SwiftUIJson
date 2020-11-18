//
//  AngularGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension AngularGradient: FullyCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case gradient, center, startAngle, endAngle, angle
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let center = try container.decodeIfPresent(UnitPoint.self, forKey: .center) ?? .center
        let startAngle = try container.decodeIfPresent(Angle.self, forKey: .startAngle) ?? .zero
        let endAngle = try container.decodeIfPresent(Angle.self, forKey: .endAngle) ?? .zero
        let angle = try container.decodeIfPresent(Angle.self, forKey: .angle) ?? .zero
//        super.init(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
//        super.init(gradient: gradient, center: center, angle: angle)
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
        //        let m = Mirror.children(reflecting: self)
        fatalError()
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(gradient, forKey: .style)
//        try container.encode(center, forKey: .design)
//        try container.encode(angle, forKey: .angle)
//        try container.encode(startAngle, forKey: .startAngle)
//        try container.encode(endAngle, forKey: .endAngle)
    }
    //: Register
    static func register() {
        DynaType.register(AngularGradient.self)
    }
}

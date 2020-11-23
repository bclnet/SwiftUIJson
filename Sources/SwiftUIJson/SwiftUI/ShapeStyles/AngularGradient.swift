//
//  AngularGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension AngularGradient: IAnyView, FullyCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case gradient, center, startAngle, endAngle
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let center = try container.decode(UnitPoint.self, forKey: .center)
        let startAngle = (try? container.decodeIfPresent(Angle.self, forKey: .startAngle)) ?? .zero
        let endAngle = (try? container.decodeIfPresent(Angle.self, forKey: .endAngle)) ?? .zero
        self.init(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "AngularGradient", keys: ["gradient", "center", "startAngle", "endAngle"])
        let m = Mirror.children(reflecting: self)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(m["gradient"]! as! Gradient, forKey: .gradient)
        try container.encode(m["center"]! as! UnitPoint, forKey: .center)
        let startAngle = m["startAngle"]! as! Angle
        let endAngle = m["endAngle"]! as! Angle
        if startAngle != .zero { try container.encode(startAngle, forKey: .startAngle) }
        if endAngle != .zero { try container.encode(endAngle, forKey: .endAngle) }
    }
    //: Register
    static func register() {
        DynaType.register(AngularGradient.self)
    }
}

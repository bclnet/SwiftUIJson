//
//  LinearGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension LinearGradient: IAnyView, FullyCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case gradient, startPoint, endPoint
    }
    public init(from decoder: Decoder, for ptype: PType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let startPoint = try container.decode(UnitPoint.self, forKey: .startPoint)
        let endPoint = try container.decode(UnitPoint.self, forKey: .endPoint)
        self.init(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "LinearGradient", keys: ["gradient", "startPoint", "endPoint"])
        let m = Mirror.children(reflecting: self)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(m["gradient"]! as! Gradient, forKey: .gradient)
        try container.encode(m["startPoint"]! as! UnitPoint, forKey: .startPoint)
        try container.encode(m["endPoint"]! as! UnitPoint, forKey: .endPoint)
    }
    //: Register
    static func register() {
        PType.register(LinearGradient.self)
    }
}

//
//  LinearGradient.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension LinearGradient: FullyCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case gradient, startPoint, endPoint
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let startPoint = try container.decode(UnitPoint.self, forKey: .startPoint)
        let endPoint = try container.decode(UnitPoint.self, forKey: .endPoint)
        self.init(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }
    public func encode(to encoder: Encoder) throws {
//        let m = Mirror.children(reflecting: self)
        fatalError()
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(gradient, forKey: .gradient)
//        try container.encode(startPoint, forKey: .startPoint)
//        try container.encode(endPoint, forKey: .endPoint)
    }
    //: Register
    static func register() {
        DynaType.register(LinearGradient.self)
    }
}

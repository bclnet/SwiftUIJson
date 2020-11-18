//
//  Gradient.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Gradient: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var stops = [Stop]()
        while !container.isAtEnd {
            let color = try container.decode(Color.self)
            let location = try container.decode(CGFloat.self)
            stops.append(Stop(color: color, location: location))
        }
        self.init(stops: stops)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Gradient", keys: ["stops"])
        var container = encoder.unkeyedContainer()
        for stop in stops {
            try container.encode(stop.color)
            try container.encode(stop.location)
        }
    }
}

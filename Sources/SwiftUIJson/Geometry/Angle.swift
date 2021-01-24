//
//  Angle.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Angle: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Angle", keys: ["radians"])
        var container = encoder.singleValueContainer()
        try container.encode(radians)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(radians: try container.decode(Double.self))
    }
}

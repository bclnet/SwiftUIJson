//
//  RotatedShape.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension RotatedShape: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
        self = RotatedShape(shape: Circle() as! Content, angle: Angle(), anchor: .center)
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
    }
    //: Register
    static func register() {
        DynaType.register(RotatedShape.self)
    }
}

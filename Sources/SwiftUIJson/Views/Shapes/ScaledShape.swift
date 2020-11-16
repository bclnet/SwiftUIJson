//
//  ScaledShape.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ScaledShape: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
        self = ScaledShape(shape: Circle() as! Content, scale: CGSize(width: 5, height: 5), anchor: .center)
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
    }
    //: Register
    static func register() {
        DynaType.register(ScaledShape.self)
    }
}

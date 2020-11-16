//
//  Path.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Path: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
        self = Path()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
    }
    //: Register
    static func register() {
        DynaType.register(Path.self)
    }
}

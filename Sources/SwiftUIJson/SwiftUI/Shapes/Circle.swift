//
//  Circle.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

// MARK: - Preamble
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Circle {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Circle: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
        self = Circle()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
    }
}

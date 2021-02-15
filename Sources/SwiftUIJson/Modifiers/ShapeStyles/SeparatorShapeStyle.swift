//
//  SeparatorShapeStyle.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension SeparatorShapeStyle: FullyCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case image, sourceRect, scale
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }
    public init(from decoder: Decoder, for ptype: PType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        fatalError()
    }

    //: Register
    static func register() {
        PType.register(SeparatorShapeStyle.self)
    }
}

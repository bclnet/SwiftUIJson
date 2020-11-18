//
//  BackgroundStyle.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension BackgroundStyle: FullyCodable {
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws { self.init() }
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        DynaType.register(BackgroundStyle.self)
    }
}

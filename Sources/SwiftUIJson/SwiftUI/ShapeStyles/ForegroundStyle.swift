//
//  ForegroundStyle.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ForegroundStyle: FullyCodable {
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws { self.init() }
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        DynaType.register(ForegroundStyle.self)
    }
}

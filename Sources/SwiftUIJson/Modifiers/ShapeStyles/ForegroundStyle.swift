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
    public func encode(to encoder: Encoder) throws {}
    public init(from decoder: Decoder, for ptype: PType) throws { self.init() }
    public init(from decoder: Decoder) throws { self.init() }

    //: Register
    static func register() {
        PType.register(ForegroundStyle.self)
    }
}

//
//  AnyHashable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

extension AnyHashable: DynaCodable {
    //: Codable
    public func encode(to encoder: Encoder) throws { fatalError("AnyHashable") }
    public init(from decoder: Decoder, for ptype: PType) throws {
        guard let value = try decoder.dynaSuperInit(for: ptype[0]) as? AnyHashable else { fatalError("AnyHashable") }
        self = value
    }
}

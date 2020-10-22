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
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        guard let value = try decoder.dynaSuperInit(for: dynaType[0], depth: depth) as? AnyHashable else { fatalError("AnyHashable") }
        self = value
    }
    public func encode(to encoder: Encoder) throws { fatalError("AnyHashable") }
}
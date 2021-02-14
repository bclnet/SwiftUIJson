//
//  JsonCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public struct NeverCodable: FullyCodable, CodableKeyPath {
    public init(from decoder: Decoder, for dynaType: DynaType) throws { fatalError("Never") }
    public init(from decoder: Decoder) throws { fatalError("Never") }
    public func encode(to encoder: Encoder) throws { fatalError("Never") }
    public static func encodeKeyPath(_ keyPath: AnyKeyPath) -> String { fatalError("Never") }
    public static func decodeKeyPath(_ keyPath: String) -> AnyKeyPath { fatalError("Never") }
}

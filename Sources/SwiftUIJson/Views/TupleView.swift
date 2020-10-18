//
//  TupleView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TupleView: JsonView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        var container = try decoder.unkeyedContainer()
        var items = [JsonView?]()
        while !container.isAtEnd {
            let baseDecoder = try container.superDecoder()
            let value = try baseDecoder.decodeDynaSuper(depth: depth + 1) as? JsonView
            items.append(value)
        }
        let value = DynaType.typeBuildTuple(dynaType[0], for: items) as! T
        self.init(value)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for value in Mirror.values(reflecting: value) {
            let baseEncoder = container.superEncoder()
            try baseEncoder.encodeDynaSuper(value)
        }
    }
}

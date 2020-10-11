//
//  TupleView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension TupleView: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension TupleView: DynaCodable {
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        var container = try decoder.unkeyedContainer()
        var items = [JsonView]()
        while !container.isAtEnd {
            let baseDecoder = try container.superDecoder()
            let item = try baseDecoder.decodeDynaSuper() as! JsonView
            items.append(item)
        }
        let value = DynaType.typeBuild(dynaType[0], for: items) as! T
        self.init(value)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for value in Mirror.values(reflecting: value) {
            guard let value = value as? Encodable else { continue }
            let baseEncoder = container.superEncoder()
            try baseEncoder.encodeDynaSuper(value)
        }
    }
}

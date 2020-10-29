//
//  TupleView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TupleView: JsonView, DynaCodable, DynaUnkeyedContainer {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        var container = try decoder.unkeyedContainer()
        //let sk = try container.decode(String.self) // eat type
        var items = [JsonView?]()
        while !container.isAtEnd {
            let baseDecoder = try container.superDecoder()
            let value = try baseDecoder.decodeDynaSuper() as? JsonView
            items.append(value)
        }
        let value = DynaType.buildType(tuple: dynaType[0], for: items) as! T
        self.init(value)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for value in Mirror.values(reflecting: value) {
            let baseEncoder = container.superEncoder()
            try baseEncoder.encodeDynaSuper(value)
        }
    }
    //: Register
    static func register() {
        DynaType.register(TupleView<(JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        DynaType.register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
    }
}

//    internal struct _TupleViewCodingKey: CodingKey {
//        let stringValue: String
//        let intValue: Int?
//        init?(stringValue: String) { self.stringValue = stringValue; self.intValue = Int(stringValue) }
//        init?(intValue: Int) { self.stringValue = "\(intValue)"; self.intValue = intValue }
//    }
//            // Keyed with Ints
//            let container = try decoder.container(keyedBy: _TupleViewCodingKey.self)
//            var items = [JsonView?]()
//            for key in container.allKeys {
//                if key.intValue != nil {
//                    let baseDecoder = try container.superDecoder(forKey: key)
//                    let value = try baseDecoder.decodeDynaSuper(depth: depth + 1) as? JsonView
//                    items.append(value)
//                }
//            }
//            let value = DynaType.typeBuildTuple(dynaType[0], for: items) as! T
//            self.init(value)

//            // Keyed with Ints
//            var container = encoder.container(keyedBy: _TupleViewCodingKey.self)
//            var key = 0
//            for value in Mirror.values(reflecting: value) {
//                let baseEncoder = container.superEncoder(forKey: _TupleViewCodingKey(intValue: key)!); key += 1
//                try baseEncoder.encodeDynaSuper(value)
//            }

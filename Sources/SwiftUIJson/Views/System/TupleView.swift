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
//    internal struct _TupleViewCodingKey: CodingKey {
//        let stringValue: String
//        let intValue: Int?
//        init?(stringValue: String) { self.stringValue = stringValue; self.intValue = Int(stringValue) }
//        init?(intValue: Int) { self.stringValue = "\(intValue)"; self.intValue = intValue }
//    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
//        if false {
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
        //        } else {
        // Default unkeyedContainer
        var container = try decoder.unkeyedContainer()
        //let sk = try container.decode(String.self) // eat type
        var items = [JsonView?]()
        while !container.isAtEnd {
            let baseDecoder = try container.superDecoder()
            let value = try baseDecoder.decodeDynaSuper() as? JsonView
            items.append(value)
        }
        let value = DynaType.typeBuildTuple(dynaType[0], for: items) as! T
        self.init(value)
        //        }
    }
    public func encode(to encoder: Encoder) throws {
        //        if false {
        //            // Keyed with Ints
        //            var container = encoder.container(keyedBy: _TupleViewCodingKey.self)
        //            var key = 0
        //            for value in Mirror.values(reflecting: value) {
        //                let baseEncoder = container.superEncoder(forKey: _TupleViewCodingKey(intValue: key)!); key += 1
        //                try baseEncoder.encodeDynaSuper(value)
        //            }
        //        } else {
        // Default unkeyedContainer
        var container = encoder.unkeyedContainer()
        for value in Mirror.values(reflecting: value) {
            let baseEncoder = container.superEncoder()
            try baseEncoder.encodeDynaSuper(value)
            //            }
        }
    }
}

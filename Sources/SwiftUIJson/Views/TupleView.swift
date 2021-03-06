//
//  TupleView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension TupleView: IAnyView, DynaCodable, DynaUnkeyedContainer {
    public var anyView: AnyView { AnyView(self) }
    
    //: Codable
    public func encode(to encoder: Encoder) throws {
        guard let context = encoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        var container = encoder.unkeyedContainer()
        for value in Mirror.values(reflecting: value) {
            let baseEncoder = container.superEncoder()
            try context.encodeDynaSuper(value, to: baseEncoder)
        }
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        guard let context = decoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        var container = try decoder.unkeyedContainer()
        //let sk = try container.decode(String.self) // eat type
        var items = [AnyView]()
        while !container.isAtEnd {
            let baseDecoder = try container.superDecoder()
            let value = try context.decodeDynaSuper(from: baseDecoder)
            items.append(AnyView.any(value))
        }
        let value = PType.buildType(tuple: ptype[0], for: items) as! T
        self.init(value)
    }

    //: Register
    static func register() {
        PType.register(TupleView<(AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
        PType.register(TupleView<(AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView, AnyView)>.self)
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
//            let value = PType.typeBuildTuple(ptype[0], for: items) as! T
//            self.init(value)

//            // Keyed with Ints
//            var container = encoder.container(keyedBy: _TupleViewCodingKey.self)
//            var key = 0
//            for value in Mirror.values(reflecting: value) {
//                let baseEncoder = container.superEncoder(forKey: _TupleViewCodingKey(intValue: key)!); key += 1
//                try baseEncoder.encodeDynaSuper(value)
//            }

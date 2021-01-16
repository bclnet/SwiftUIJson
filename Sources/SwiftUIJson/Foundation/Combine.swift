//
//  Combine.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Combine
import Foundation

//extension AnyPublisher: DynaCodable {
//    //: Codable
//    enum CodingKeys: CodingKey {
//        case value
//    }
//    public init(from decoder: Decoder, for ptype: PType) throws {
//        let value = try decoder.dynaSuperInit(for: ptype[0])
//        switch ptype.underlyingKey {
//        case "__C.NSTimer.TimerPublisher" where AnyPublisher.Output == Timer.TimerPublisher.Output && AnyPublisher.Failure == Timer.TimerPublisher.Failure:
//            let abc = value as! Timer.TimerPublisher
//            let xyz = abc.eraseToAnyPublisher()
//            self = xyz
//            fatalError()
////        case "Combine.PassthroughSubject":
////        case "Combine.CurrentValueSubject":
//        case let unrecognized: fatalError(unrecognized)
//        }
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(true, forKey: .value)
//    }
//}

extension PassthroughSubject: DynaCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case value
    }
    public convenience init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let _ = try container.decode(Bool.self, forKey: .value)
        self.init()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(true, forKey: .value)
    }
}

extension CurrentValueSubject: DynaCodable where Output : Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case value
    }
    public convenience init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Output.self, forKey: .value)
        self.init(value)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }
}

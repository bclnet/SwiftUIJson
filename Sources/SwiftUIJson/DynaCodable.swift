//
//  DynaCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

protocol DynaUnkeyedContainer { }

//public protocol DynaEncodableByAny {
//    func encode(any s: Any, to encode: Encodable)
//}

//: Codable
fileprivate enum CodingKeys: CodingKey {
    case type
}

fileprivate func printPath(_ value: String) {
    //Swift.print(value)
}

public struct NeverCodable: Codable {
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

extension DynaTypeWithNil: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension DynaType: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Encoder {
    public func encodeDynaSuper(_ value: Any) throws {
//        let unwrap = AnyView.unwrap(value: Mirror.unwrap(value: value))
        let unwrap = Mirror.unwrap(value: value)
        let hasNil: Bool; if case Optional<Any>.none = value { hasNil = true } else { hasNil =  false }
        let dynaTypeWithNil = DynaTypeWithNil(try DynaType.type(for: type(of: value).self), hasNil: hasNil)
        if value is DynaUnkeyedContainer {
            var container = self.unkeyedContainer()
            try container.encode(dynaTypeWithNil)
        } else {
            var container = self.container(keyedBy: CodingKeys.self)
            try container.encode(dynaTypeWithNil, forKey: .type)
        }
        if hasNil { return }
        guard let encodeable = unwrap as? Encodable else {
            throw DynaTypeError.typeNotCodable("encodeDynaSuper", key: DynaType.typeKey(for: unwrap))
        }
        try encodeable.encode(to: self)
    }
}

extension Decoder {
    public func decodeDynaSuper() throws -> Any {
        let dynaTypeWithNil: DynaTypeWithNil
        do {
            var container = try self.unkeyedContainer()
            dynaTypeWithNil = try container.decode(DynaTypeWithNil.self)
        } catch {
            let container = try self.container(keyedBy: CodingKeys.self)
            dynaTypeWithNil = try container.decode(DynaTypeWithNil.self, forKey: .type)
        }
        if dynaTypeWithNil.hasNil {
            printPath("\(String(repeating: "+", count: codingPath.count)) nil \(codingPath)")
            return Optional<Any>.none as Any
        }
        let dynaType = dynaTypeWithNil.dynaType
        printPath("\(String(repeating: "+", count: codingPath.count)) \(dynaType.underlyingType) \(codingPath)")
        return try dynaSuperInit(for: dynaType)
    }

    public func dynaSuperInit(for dynaType: DynaType) throws -> Any {
        switch dynaType {
        case .type(let type, let key):
            let unwrap = DynaType.unwrap(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else {
                    throw DynaTypeError.typeNotCodable("dynaSuperInit", key: key)
                }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: dynaType)
        case .tuple(let type, let key, _), .generic(let type, let key, _, _):
            let unwrap = DynaType.unwrap(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else {
                    throw DynaTypeError.typeNotCodable("dynaSuperInit", key: key)
                }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: dynaType)
        }
    }
}

// MARK: - DynaCodable

/// A type that can decode itself from an external representation.
public protocol DynaDecodable {
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Parameter dynaType: The dyanType to build.
    init(from decoder: Decoder, for dynaType: DynaType) throws
}

/// A type that can convert itself into and out of an external representation.
///
/// `Codable` is a type alias for the `Encodable` and `DynaDecodable` protocols.
/// When you use `DynaCodable` as a type or a generic constraint, it matches
/// any type that conforms to both protocols.
public typealias DynaCodable = Encodable & DynaDecodable

/// A type that can convert itself into and out of an external representation.
///
/// `DynaFullCodable` is a type alias for the `Encodable` and `Decodable` and `DynaDecodable` protocols.
/// When you use `DynaFullCodable` as a type or a generic constraint, it matches
/// any type that conforms to these protocols.
public typealias DynaFullCodable = Encodable & Decodable & DynaDecodable

public typealias DynaConvertedCodable = DynaConvertable & Encodable & Decodable

public typealias DynaConvertedDynaCodable = DynaConvertable & Encodable & DynaDecodable

extension UnkeyedEncodingContainer {
    public mutating func encodeAny<T>(_ value: T) throws {
        let baseEncoder = superEncoder()
        guard let encodable = value as? Encodable else {
            let newValue = try DynaType.convert(value: value)
            guard let encodable2 = newValue as? Encodable else {
                throw DynaTypeError.typeNotCodable("encodeAny", key: DynaType.typeKey(for: value))
            }
            try encodable2.encode(to: baseEncoder)
            return
        }
        try encodable.encode(to: baseEncoder)
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeAny<T>(_ value: T, forKey key: Key) throws {
        let baseEncoder = superEncoder(forKey: key)
        guard let encodable = value as? Encodable else {
            let newValue = try DynaType.convert(value: value)
            guard let encodable2 = newValue as? Encodable else {
                throw DynaTypeError.typeNotCodable("encodeAny", key: DynaType.typeKey(for: value))
            }
            try encodable2.encode(to: baseEncoder)
            return
        }
        try encodable.encode(to: baseEncoder)
    }
}


extension UnkeyedDecodingContainer {
    public mutating func decodeAny<T>(_ type: T.Type) throws -> T {
        let baseDecoder = try superDecoder()
        guard let decodable = type as? Decodable.Type else {
//            let newValue = try DynaType.convert(value: value)
//            guard let encodable2 = newValue as? Encodable else {
                throw DynaTypeError.typeNotCodable("decodeAny", key: DynaType.typeKey(for: type))
//            }
//            try encodable2.encode(to: baseDecoder)
//            return
        }
        return try decodable.init(from: baseDecoder) as! T
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeAny<T>(_ type: T.Type, forKey key: Key) throws -> T {
        let baseDecoder = try superDecoder(forKey: key)
        guard let decodable = type as? Decodable.Type else {
            print("HERE")
//            let newValue = try DynaType.convert(value: value)
//            guard let encodable2 = newValue as? Encodable else {
                throw DynaTypeError.typeNotCodable("decodeAny", key: DynaType.typeKey(for: type))
//            }
//            try encodable2.encode(to: baseDecoder)
//            return
        }
        print("\(T.self)")
        return try decodable.init(from: baseDecoder) as! T
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - Parameter dynaType: The dyanType to build.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    public func decode<T: DynaDecodable>(_ type: T.Type, forKey key: Key, dynaType: DynaType) throws -> T {
        let decoder = try superDecoder(forKey: key)
        printPath("\(String(repeating: "-", count: codingPath.count)) \(dynaType.underlyingType) \(codingPath)")
        return try type.init(from: decoder, for: dynaType)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - Parameter dynaType: The dyanType to build.
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent<T: DynaDecodable>(_ type: T.Type, forKey key: Key, dynaType: DynaType) throws -> T? {
        if !contains(key) {
            printPath("\(String(repeating: "-", count: codingPath.count)) nil \(codingPath)")
            return nil
        }
        let decoder = try superDecoder(forKey: key)
        printPath("\(String(repeating: "-", count: codingPath.count)) \(dynaType.underlyingType) \(codingPath)")
        return try type.init(from: decoder, for: dynaType)
    }
}

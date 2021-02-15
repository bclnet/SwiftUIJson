//
//  DynaCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

protocol DynaUnkeyedContainer { }

//: Codable
fileprivate enum CodingKeys: CodingKey {
    case type
}

fileprivate func printPath(_ value: String) {
//    Swift.print(value)
}

extension PTypeWithNil: Codable {
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
        let hasNil: Bool; if case Optional<Any>.none = value { hasNil = true } else { hasNil = false }
        let ptypeWithNil = PTypeWithNil(try PType.type(for: type(of: value).self), hasNil: hasNil)
        if value is DynaUnkeyedContainer {
            var container = self.unkeyedContainer()
            try container.encode(ptypeWithNil)
        } else {
            var container = self.container(keyedBy: CodingKeys.self)
            try container.encode(ptypeWithNil, forKey: .type)
        }
        if hasNil { return }
        let unwrap = Mirror.optional(any: value)!
        guard let encodable = unwrap as? Encodable else {
            let newValue = try PType.convert(value: unwrap)
            guard let encodable2 = newValue as? Encodable else {
                throw PTypeError.typeNotCodable("encodeDynaSuper", key: PType.typeKey(for: unwrap))
            }
            try encodable2.encode(to: self)
            return
        }
        try encodable.encode(to: self)
    }
}

extension Decoder {
    public func decodeDynaSuper() throws -> Any {
        let ptypeWithNil: PTypeWithNil
        do {
            var container = try self.unkeyedContainer()
            ptypeWithNil = try container.decode(PTypeWithNil.self)
        } catch {
            let container = try self.container(keyedBy: CodingKeys.self)
            ptypeWithNil = try container.decode(PTypeWithNil.self, forKey: .type)
        }
        if ptypeWithNil.hasNil {
            printPath("\(String(repeating: "+", count: codingPath.count)) nil \(codingPath)")
            return Optional<Any>.none as Any
        }
        let ptype = ptypeWithNil.ptype
        printPath("\(String(repeating: "+", count: codingPath.count)) \(ptype.underlyingType) \(codingPath)")
        return try dynaSuperInit(for: ptype)
    }

    public func dynaSuperInit(for ptype: PType) throws -> Any {
        switch ptype {
        case .type(let type, let key):
            let unwrap = PType.optional(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else {
                    throw PTypeError.typeNotCodable("dynaSuperInit", key: key)
                }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: ptype)
        case .tuple(let type, let key, _), .generic(let type, let key, _, _):
            let unwrap = PType.optional(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else {
                    throw PTypeError.typeNotCodable("dynaSuperInit", key: key)
                }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: ptype)
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
    /// - Parameter ptype: The dyanType to build.
    init(from decoder: Decoder, for ptype: PType) throws
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
public typealias FullyCodable = Encodable & Decodable & DynaDecodable

public typealias ConvertibleCodable = Convertible & Encodable & Decodable

public typealias ConvertibleDynaCodable = Convertible & Encodable & DynaDecodable

extension UnkeyedEncodingContainer {
    public mutating func encodeAny<T>(_ value: T) throws {
        let baseEncoder = superEncoder()
        guard let encodable = value as? Encodable else {
            let newValue = try PType.convert(value: value)
            guard let encodable2 = newValue as? Encodable else {
                throw PTypeError.typeNotCodable("encodeAny", key: PType.typeKey(for: value))
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
            let newValue = try PType.convert(value: value)
            guard let encodable2 = newValue as? Encodable else {
                throw PTypeError.typeNotCodable("encodeAny", key: PType.typeKey(for: value))
            }
            try encodable2.encode(to: baseEncoder)
            return
        }
        try encodable.encode(to: baseEncoder)
    }
}

extension UnkeyedDecodingContainer {
    public mutating func decodeAny<T>(_ type: T.Type, ptype: PType) throws -> T {
        let decoder = try superDecoder()
        let newType = ptype.underlyingType
        guard let decodable = newType as? DynaDecodable.Type else {
            guard let decodable2 = newType as? Decodable.Type else {
                throw PTypeError.typeNotCodable("decodeAny", key: PType.typeKey(for: newType))
            }
            return try decodable2.init(from: decoder) as! T
        }
        return try decodable.init(from: decoder, for: ptype) as! T
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeAny<T>(_ type: T.Type, forKey key: Key, ptype: PType) throws -> T {
        let decoder = try superDecoder(forKey: key)
        let newType = ptype.underlyingType
        guard let decodable = newType as? DynaDecodable.Type else {
            guard let decodable2 = newType as? Decodable.Type else {
                throw PTypeError.typeNotCodable("decodeAny", key: PType.typeKey(for: newType))
            }
            return try decodable2.init(from: decoder) as! T
        }
        return try decodable.init(from: decoder, for: ptype) as! T
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - Parameter ptype: The dyanType to build.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    public func decode<T>(_ type: T.Type, forKey key: Key, ptype: PType) throws -> T where T : DynaDecodable {
        printPath("\(String(repeating: "-", count: codingPath.count)) \(ptype.underlyingType) \(codingPath)")
        let decoder = try superDecoder(forKey: key)
        return try type.init(from: decoder, for: ptype)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - Parameter ptype: The dyanType to build.
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: Key, ptype: PType) throws -> T? where T : DynaDecodable {
        if !contains(key) {
//            printPath("\(String(repeating: "-", count: codingPath.count)) nil \(codingPath)")
            return nil
        }
        printPath("\(String(repeating: "-", count: codingPath.count)) \(ptype.underlyingType) \(codingPath)")
        let decoder = try superDecoder(forKey: key)
        return try type.init(from: decoder, for: ptype)
    }
}

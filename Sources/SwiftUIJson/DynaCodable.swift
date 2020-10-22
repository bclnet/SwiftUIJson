//
//  DynaCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

protocol DynaUnkeyed { }

//: Codable
fileprivate enum CodingKeys: CodingKey {
    case type
}

fileprivate func printPath(_ value: String) {
    //Swift.print(value)
}

extension Encoder {
    public func encodeDynaSuper(_ value: Any) throws {
        let unwrap = Mirror.unwrap(value: value)
//        let unwrap = AnyView.unwrap(value: Mirror.unwrap(value: value))
        let hasNil: Bool; if case Optional<Any>.none = value { hasNil = true } else { hasNil =  false }
        let dynaTypeWithNil = DynaTypeWithNil(try DynaType.type(for: type(of: value).self), hasNil: hasNil)
        if value is DynaUnkeyed {
            var container = self.unkeyedContainer()
            try container.encode(dynaTypeWithNil)
        } else {
            var container = self.container(keyedBy: CodingKeys.self)
            try container.encode(dynaTypeWithNil, forKey: .type)
        }
        if hasNil { return }
        guard let encodeable = unwrap as? Encodable else { throw DynaTypeError.typeNotCodable(named: String(reflecting: value)) }
        try encodeable.encode(to: self)
    }
}

extension Decoder {
    public func decodeDynaSuper(depth: Int) throws -> Any {
        let dynaTypeWithNil: DynaTypeWithNil
        do {
            var container = try self.unkeyedContainer()
            dynaTypeWithNil = try container.decode(DynaTypeWithNil.self)
        } catch {
            let container = try self.container(keyedBy: CodingKeys.self)
            dynaTypeWithNil = try container.decode(DynaTypeWithNil.self, forKey: .type)
        }
        if dynaTypeWithNil.hasNil {
            printPath("\(String(repeating: "+", count: depth)) nil \(self.codingPath)")
            return Optional<Any>.none as Any
        }
        let dynaType = dynaTypeWithNil.dynaType
        printPath("\(String(repeating: "+", count: depth)) \(dynaType.underlyingType) \(self.codingPath)")
        return try dynaSuperInit(for: dynaType, depth: depth)
    }

    public func dynaSuperInit(for dynaType: DynaType, depth: Int) throws -> Any {
        switch dynaType {
        case .type(let type, let name):
            let unwrap = DynaType.unwrap(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else { throw DynaTypeError.typeNotCodable(named: name) }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: dynaType, depth: depth)
        case .tuple(let type, let name, _), .generic(let type, let name, _):
            let unwrap = DynaType.unwrap(type: type)
            guard let decodable = unwrap as? DynaDecodable.Type else {
                guard let decodable2 = unwrap as? Decodable.Type else { throw DynaTypeError.typeNotCodable(named: name) }
                return try decodable2.init(from: self)
            }
            return try decodable.init(from: self, for: dynaType, depth: depth)
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
    init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws
}

/// A type that can convert itself into and out of an external representation.
///
/// `Codable` is a type alias for the `Encodable` and `Decodable` protocols.
/// When you use `Codable` as a type or a generic constraint, it matches
/// any type that conforms to both protocols.
public typealias DynaCodable = Encodable & DynaDecodable

extension KeyedDecodingContainerProtocol {
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    public func decode<T: DynaDecodable>(_ type: T.Type, forKey key: Key, dynaType: DynaType, depth: Int) throws -> T {
        let decoder = try superDecoder(forKey: key)
        printPath("\(String(repeating: "-", count: depth)) \(dynaType.underlyingType) \(self.codingPath)")
        return try type.init(from: decoder, for: dynaType, depth: depth)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent<T: DynaDecodable>(_ type: T.Type, forKey key: Key, dynaType: DynaType, depth: Int) throws -> T? {
        if !contains(key) {
            printPath("\(String(repeating: "-", count: depth)) nil \(self.codingPath)")
            return nil
        }
        let decoder = try superDecoder(forKey: key)
        printPath("\(String(repeating: "-", count: depth)) \(dynaType.underlyingType) \(self.codingPath)")
        return try type.init(from: decoder, for: dynaType, depth: depth)
    }
}

//
//  DynaCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

// MARK - Codable
enum CodingKeys: CodingKey {
    case type
}

extension Encoder {
    public func encodeDynaSuper(_ value: Encodable) throws {
        var container = self.container(keyedBy: CodingKeys.self)
        try container.encode(DynaType.type(for: type(of: value).self), forKey: .type)
        try value.encode(to: self)
    }
}

extension Decoder {
    public func decodeDynaSuper() throws -> Any {
        let container = try self.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DynaType.self, forKey: .type)
        return try dynaSuperInit(for: type)
    }
    
    public func dynaSuperInit(for dynaType: DynaType, index: Int = -1) throws -> Any {
        switch dynaType[index] {
        case .type(let type, let name):
            guard let decodableType = type as? DynaDecodable.Type else {
                guard let decodableType2 = type as? Decodable.Type else { throw DynaTypeError.typeNotCodable(named: name) }
                return try decodableType2.init(from: self)
            }
            return try decodableType.init(from: self, for: dynaType)
        case .tuple(let type, let name, _), .generic(let type, let name, _):
            guard let decodableType = type as? DynaDecodable.Type else {
                guard let decodableType2 = type as? Decodable.Type else { throw DynaTypeError.typeNotCodable(named: name) }
                return try decodableType2.init(from: self)
            }
            return try decodableType.init(from: self, for: dynaType)
        }
    }
}

// MARK - DynaDecodable

/// A type that can decode itself from an external representation.
public protocol DynaDecodable {
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    init(from decoder: Decoder, for dynaType: DynaType) throws
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
    public func decode<T: DynaDecodable>(
        _ type: T.Type,
        forKey key: Key,
        dynaType: DynaType
    ) throws -> T {
        //        let _box = Mirror(reflecting: self).descendant("_box")!; print(_box)
        let decoder = try superDecoder(forKey: key)
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
    /// - returns: A decoded value of the requested type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    public func decodeIfPresent<T: DynaDecodable>(
        _ type: T.Type,
        forKey key: Key
    ) throws -> T? {
        fatalError()
    }
}

//
//  JsonCodeable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension KeyedDecodingContainerProtocol {
    public func decodeAction(forKey key: Key) throws -> () -> Void {
        return { print("action") }
    }
    public func decodeAction<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> (T) -> Void {
        return { a in print("action") }
    }
    public func decodeAction<T1: Decodable, T2: Decodable>(_ type1: T1.Type, _ type2: T2.Type, forKey key: Key) throws -> (T1, T2) -> Void {
        return { a, b in print("action") }
    }
    
    public func decodeActionIfPresent(forKey key: Key) throws -> (() -> Void)? {
        return nil
    }
    public func decodeActionIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> ((T) -> Void)? {
        return nil
    }
    public func decodeActionIfPresent<T1: Decodable, T2: Decodable>(_ type1: T1.Type, _ type2: T2.Type, forKey key: Key) throws -> ((T1, T2) -> Void)? {
        return nil
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeAction(_ value: () -> Void, forKey key: Key) throws {
    }
    public mutating func encodeAction<T: Encodable>(_ value: (T) -> Void, forKey key: Key) throws {
    }
    public mutating func encodeAction<T1: Encodable, T2: Encodable>(_ value: (T1, T2) -> Void, forKey key: Key) throws {
    }
    
    public mutating func encodeActionIfPresent(_ value: (() -> Void)?, forKey key: Key) throws {
    }
    public mutating func encodeActionIfPresent<T: Encodable>(_ value: ((T) -> Void)?, forKey key: Key) throws {
    }
    public mutating func encodeActionIfPresent<T1: Encodable, T2: Encodable>(_ value: ((T1, T2) -> Void)?, forKey key: Key) throws {
    }
}

//
//  DataManager.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

public protocol CodableKeyPath {
    static func encodeKeyPath(_ keyPath: AnyKeyPath) -> String
    static func decodeKeyPath(_ keyPath: String) -> AnyKeyPath
}

public struct DataManager {
    static var dataKeys = [ObjectIdentifier:String]()
    static var dataValues = [String:Any]()
    
    public static func data<Data>(add data: Data, forKey key: String) -> String where Data : RandomAccessCollection {
        let id = ObjectIdentifier(data as AnyObject)
        guard let kv = dataKeys[id] else {
            dataKeys[id] = key
            dataValues[key] = data
            return key
        }
        return kv
    }
    
    public static func data<Data>(find key: String, _ type: Data.Type) -> Data where Data : RandomAccessCollection {
        guard let kv = dataValues[key] else { fatalError() }
        return kv as! Data
    }
    
    public static func defaultValue<Element>(_ type: Element.Type) -> Element {
        let key = DynaType.typeKey(for: type)
        guard let value = defaultValues[key] else { fatalError() }
        return value as! Element
    }
    
    // MARK: - Register
    static var defaultValues = [String:Any]()
    
    public static func register<T>(_ type: T.Type, _ defaultValue: T) {
        DynaType.register(type)
        let key = DynaType.typeKey(for: type)
        if defaultValues[key] == nil {
            defaultValues[key] = defaultValue
        }
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeData<Data>(forKey key: Key) throws -> Data where Data : RandomAccessCollection {
        DataManager.data(find: try self.decode(String.self, forKey: key), Data.self)
    }
    
    public func decodeDataIfPresent<Data>(forKey key: Key) throws -> Data? where Data : RandomAccessCollection {
        if try decodeNil(forKey: key) { return nil }
        return DataManager.data(find: try self.decode(String.self, forKey: key), Data.self)
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeData<Data>(_ data: Data, forKey key: Key) throws where Data : RandomAccessCollection {
        try self.encode(DataManager.data(add: data, forKey: UUID().description), forKey: key)
    }
    
    public mutating func encodeDataIfPresent<Data>(_ data: Data?, forKey key: Key) throws where Data : RandomAccessCollection {
        guard let data = data else { try self.encodeNil(forKey: key); return }
        try self.encode(DataManager.data(add: data, forKey: UUID().description), forKey: key)
    }
}

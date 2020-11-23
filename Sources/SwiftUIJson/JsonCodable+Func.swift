//
//  JsonCodeable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public class ActionManager {
    static var actionKeys = [ObjectIdentifier:String]()
    static var actionValues = [String:Any]()
    static var funcKeys = [ObjectIdentifier:String]()
    static var funcValues = [String:Any]()
    
    public static func action(add value: @escaping () -> Void, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = actionKeys[id] else {
            let foo = value as (@convention(block) () -> Void)
            actionKeys[id] = key
            actionValues[key] = foo
            return key
        }
        return kv
    }
    public static func action<T>(add value: @escaping (T) -> (Void), _ type: T.Type, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = actionKeys[id] else {
            let foo = { (t: Any) in value(t as! T) } as (@convention(block) (Any) -> Void)
            actionKeys[id] = key
            actionValues[key] = foo
            return key
        }
        return kv
    }
    public static func action<T1, T2>(add value: @escaping (T1, T2) -> Void, _ type1: T1.Type, _ type2: T2.Type, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = actionKeys[id] else {
            let foo = { (t1: Any, t2: Any) in value(t1 as! T1, t2 as! T2) } as (@convention(block) (Any, Any) -> Void)
            actionKeys[id] = key
            actionValues[key] = foo
            return key
        }
        return kv
    }
    
    public static func `func`<Result>(add value: @escaping () -> Result, _ result: Result.Type, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = funcKeys[id] else {
            let foo = { value() as Any } as (@convention(block) () -> Any)
            funcKeys[id] = key
            funcValues[key] = foo
            return key
        }
        return kv
    }
    public static func `func`<T, Result>(add value: @escaping (T) -> Result, _ type: T.Type, _ result: Result.Type, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = funcKeys[id] else {
            let foo = { (t: Any) in value(t as! T) as Any } as (@convention(block) (Any) -> Any)
            funcKeys[id] = key
            funcValues[key] = foo
            return key
        }
        return kv
    }
    public static func `func`<T1, T2, Result>(add value: @escaping (T1, T2) -> Result, _ type1: T1.Type, _ type2: T2.Type, _ result: Result.Type, forKey key: String) -> String {
        let id = ObjectIdentifier(value as AnyObject)
        guard let kv = funcKeys[id] else {
            let foo = { (t1: Any, t2: Any) in value(t1 as! T1, t2 as! T2) as Any } as (@convention(block) (Any, Any) -> Any)
            funcKeys[id] = key
            funcValues[key] = foo
            return key
        }
        return kv
    }
    
    public static func action(find key: String) -> () -> Void {
        guard let kv = actionValues[key] else { fatalError() }
        return kv as! (@convention(block) () -> Void)
    }
    public static func action<T>(find key: String, _ type: T.Type) -> (T) -> Void {
        guard let kv = actionValues[key] else { fatalError() }
        return kv as! (@convention(block) (Any) -> Void)
    }
    public static func action<T1, T2>(find key: String, _ type1: T1.Type, _ type2: T2.Type) -> (T1, T2) -> Void {
        guard let kv = actionValues[key] else { fatalError() }
        return kv as! (@convention(block) (Any, Any) -> Void)
    }

    public static func `func`<Result>(find key: String, _ result: Result.Type) -> () -> Result {
        guard let kv = funcValues[key] else { fatalError() }
        let foo = kv as! (@convention(block) () -> Any)
        return {
            let result = foo()
            guard Result.self != AnyView.self else {
                guard let value = result as? IAnyView else { fatalError("AnyView") }
                return value.anyView as! Result
            }
            return result as! Result
        }
    }
    public static func `func`<T, Result>(find key: String, _ type: T.Type, _ result: Result.Type) -> (T) -> Result {
        guard let kv = funcValues[key] else { fatalError() }
        let foo = kv as! (@convention(block) (Any) -> Any)
        return { t in
            let result = foo(t)
            guard Result.self != AnyView.self else {
                guard let value = result as? IAnyView else { fatalError("AnyView") }
                return value.anyView as! Result
            }
            return result as! Result
        }
    }
    public static func `func`<T1, T2, Result>(find key: String, _ type1: T1.Type, _ type2: T2.Type, _ result: Result.Type) -> (T1, T2) -> Result {
        guard let kv = funcValues[key] else { fatalError() }
        let foo = kv as! (@convention(block) (Any, Any) -> Any)
        return { t1, t2 in
            let result = foo(t1, t2)
            guard Result.self != AnyView.self else {
                guard let value = result as? IAnyView else { fatalError("AnyView") }
                return value.anyView as! Result
            }
            return result as! Result
        }
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeAction(forKey key: Key) throws -> () -> Void {
        ActionManager.action(find: try self.decode(String.self, forKey: key))
    }
    public func decodeAction<T>(_ type: T.Type, forKey key: Key) throws -> (T) -> Void {
        ActionManager.action(find: try self.decode(String.self, forKey: key), type)
    }
    public func decodeAction<T1, T2>(_ type1: T1.Type, _ type2: T2.Type, forKey key: Key) throws -> (T1, T2) -> Void {
        ActionManager.action(find: try self.decode(String.self, forKey: key), type1, type2)
    }
    
    public func decodeFunc<Result>(_ result: Result.Type, forKey key: Key) throws -> () -> Result {
        ActionManager.func(find: try self.decode(String.self, forKey: key), result)
    }
    public func decodeFunc<T, Result>(_ type: T.Type, _ result: Result.Type, forKey key: Key) throws -> (T) -> Result {
        ActionManager.func(find: try self.decode(String.self, forKey: key), type, result)
    }
    public func decodeFunc<T1, T2, Result>(_ type1: T1.Type, _ type2: T2.Type, _ result: Result.Type, forKey key: Key) throws -> (T1, T2) -> Result {
        ActionManager.func(find: try self.decode(String.self, forKey: key), type1, type2, result)
    }
    
    public func decodeActionIfPresent(forKey key: Key) throws -> (() -> Void)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.action(find: try self.decode(String.self, forKey: key))
    }
    public func decodeActionIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> ((T) -> Void)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.action(find: try self.decode(String.self, forKey: key), type)
    }
    public func decodeActionIfPresent<T1, T2>(_ type1: T1.Type, _ type2: T2.Type, forKey key: Key) throws -> ((T1, T2) -> Void)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.action(find: try self.decode(String.self, forKey: key), type1, type2)
    }
    
    public func decodeFuncIfPresent<Result>(result: Result.Type, forKey key: Key) throws -> (() -> Result)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.func(find: try self.decode(String.self, forKey: key), result)
    }
    public func decodeFuncIfPresent<T, Result>(_ type: T.Type, _ result: Result.Type, forKey key: Key) throws -> ((T) -> Result)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.func(find: try self.decode(String.self, forKey: key), type, result)
    }
    public func decodeFuncIfPresent<T1, T2, Result>(_ type1: T1.Type, _ type2: T2.Type, _ result: Result.Type, forKey key: Key) throws -> ((T1, T2) -> Result)? {
        if try decodeNil(forKey: key) { return nil }
        return ActionManager.func(find: try self.decode(String.self, forKey: key), type1, type2, result)
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeAction(_ value: @escaping () -> Void, forKey key: Key) throws {
        try self.encode(ActionManager.action(add: value, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeAction<T>(_ value: @escaping (T) -> Void, forKey key: Key) throws {
        try self.encode(ActionManager.action(add: value, T.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeAction<T1, T2>(_ value: @escaping (T1, T2) -> Void, forKey key: Key) throws {
        try self.encode(ActionManager.action(add: value, T1.self, T2.self, forKey: UUID().description), forKey: key)
    }
    
    public mutating func encodeFunc<Result>(_ value: @escaping () -> Result, forKey key: Key) throws {
        try self.encode(ActionManager.func(add: value, Result.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeFunc<T, Result>(_ value: @escaping (T) -> Result, forKey key: Key) throws {
        try self.encode(ActionManager.func(add: value, T.self, Result.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeFunc<T1, T2, Result>(_ value: @escaping (T1, T2) -> Result, forKey key: Key) throws {
        try self.encode(ActionManager.func(add: value, T1.self, T2.self, Result.self, forKey: UUID().description), forKey: key)
    }
    
    public mutating func encodeActionIfPresent(_ value: (() -> Void)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.action(add: value, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeActionIfPresent<T>(_ value: ((T) -> Void)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.action(add: value, T.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeActionIfPresent<T1, T2>(_ value: ((T1, T2) -> Void)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.action(add: value, T1.self, T2.self, forKey: UUID().description), forKey: key)
    }
    
    public mutating func encodeFuncIfPresent<Result>(_ value: (() -> Result)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.func(add: value, Result.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeFuncIfPresent<T, Result>(_ value: ((T) -> Result)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.func(add: value, T.self, Result.self, forKey: UUID().description), forKey: key)
    }
    public mutating func encodeFuncIfPresent<T1, T2, Result>(_ value: ((T1, T2) -> Result)?, forKey key: Key) throws {
        guard let value = value else { try self.encodeNil(forKey: key); return }
        try self.encode(ActionManager.func(add: value, T1.self, T2.self, Result.self, forKey: UUID().description), forKey: key)
    }
}

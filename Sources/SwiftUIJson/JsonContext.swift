//
//  JsonContext.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension CodingUserInfoKey {
    public static let json = CodingUserInfoKey(rawValue: "jsonData")!
    public static let jsonContext = CodingUserInfoKey(rawValue: "jsonContext")!
}

public enum JsonContextError: Error {
    case hintNotFound(name: String, message: String)
}

public class JsonContext: Codable {
    // MARK: - Static
    static var cachedContexts = NSMapTable<NSString, JsonContext>.init(
        keyOptions: .copyIn,
        valueOptions: .weakMemory
    )

    public static func remove(_ index: Any) {
        let key = String(reflecting: index) as NSString
        cachedContexts.removeObject(forKey: key); print("delContext: [\(key)]")
    }
    
    public static subscript(index: Any) -> JsonContext {
        let key = String(reflecting: index) as NSString
        guard let context = cachedContexts.object(forKey: key) else {
            let newContext = JsonContext(); print("newContext: [\(key)]")
            cachedContexts.setObject(newContext, forKey: key)
            return newContext
        }
        return context
    }
        
    // MARK: - Instance
    private var state: [AnyHashable:[AnyHashable:Any]] = [AnyHashable:[AnyHashable:Any]]()
    var slots: [String:Slot]
    private var contexts: [String:JsonContext]
    
    public subscript(index: Any) -> [AnyHashable:Any] {
        let key = index as! AnyHashable
        guard let state = state[key] else {
            let newState = [AnyHashable:Any]()
            self.state[key] = newState
            return newState
        }
        return state
    }
    
    public init() {
        slots = [String:Slot]()
        contexts = [String:JsonContext]()
    }
    
    public func encodeDynaSuper(_ value: Any, to encoder: Encoder) throws {
        guard let anyState = value as? _AnyStateWrapper else {
            try encoder.encodeDynaSuper(value)
            return
        }
        try encoder.encodeDynaSuper(anyState.content)
    }
    public func dynaSuperInit(from decoder: Decoder, for dynaType: DynaType) throws -> Any {
        try decoder.dynaSuperInit(for: dynaType)
    }
    public func decodeDynaSuper(from decoder: Decoder) throws -> Any {
        try decoder.decodeDynaSuper()
    }
    
    //: Codable
    struct _CodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        init?(stringValue: String) { self.stringValue = stringValue; self.intValue = Int(stringValue) }
        init?(intValue: Int) { self.stringValue = "\(intValue)"; self.intValue = intValue }
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _CodingKey.self)
        var slots: [String:Slot]?
        var contexts = [String:JsonContext]()
        for key in container.allKeys {
            switch key.stringValue {
            case "slots": slots = try container.decode([String:Slot].self, forKey: key)
            default: contexts[key.stringValue] = try container.decode(JsonContext.self, forKey: key)
            }
        }
        self.slots = slots ?? [String:Slot]()
        self.contexts = contexts
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _CodingKey.self)
        if !slots.isEmpty { try container.encode(slots, forKey: _CodingKey(stringValue: "slots")!) }
        for context in contexts {
            try container.encode(context.value, forKey: _CodingKey(stringValue: context.key)!)
        }
    }
}

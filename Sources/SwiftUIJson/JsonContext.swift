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

public class JsonContext: Codable {
    // MARK: - Static
    static var cachedContexts = NSMapTable<NSString, JsonContext>.init(
        keyOptions: .copyIn,
        valueOptions: .weakMemory
    )

    public static func remove(_ index: Any) {
        let key = String(reflecting: index) as NSString
        cachedContexts.removeObject(forKey: key)
    }
    
    public static subscript(index: Any) -> JsonContext {
        let key = String(reflecting: index) as NSString
        guard let context = cachedContexts.object(forKey: key) else {
            let newContext = JsonContext() //; print("context: [\(key)]")
            cachedContexts.setObject(newContext, forKey: key)
            return newContext
        }
        return context
    }
    
    // MARK: - Instance
    struct JsonSlot: Codable {
        public let type: DynaType
        public let value: Any
        //: Codable
        enum CodingKeys: CodingKey {
            case type, `default`
        }
        public init<T>(_ type: T.Type, value: Any) {
            self.type = try! DynaType.type(for: type)
            self.value = value
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(DynaType.self, forKey: .type)
            let baseDecoder = try container.superDecoder(forKey: .default)
            value = try baseDecoder.dynaSuperInit(for: type)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            guard let value = value as? Encodable else { fatalError() }
            let baseEncoder = container.superEncoder(forKey: .default)
            try value.encode(to: baseEncoder)
        }
    }
    
    var slots: [String:JsonSlot]
    
    public init() {
        slots = [String:JsonSlot]()
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case slots
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slots = try container.decodeIfPresent([String:JsonSlot].self, forKey: .slots) ?? [String:JsonSlot]()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !slots.isEmpty { try container.encode(slots, forKey: .slots) }
    }
}

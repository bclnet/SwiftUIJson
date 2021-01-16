//
//  DataType.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation
import Combine

public protocol Convertible {
    init(any: Any)
}

public enum PTypeError: Error {
    case typeNotFound(named: String)
    case typeParseError(key: String)
    case typeNameError(actual: String, expected: String)
    case typeNotCodable(_ mode: String, key: String)
}

public enum PType: RawRepresentable, Codable {
    case type(_ type: Any.Type, _ key: String)
    case tuple(_ type: Any.Type, _ key: String, _ components: [Self])
    case generic(_ type: Any.Type, _ key: String, _ any: String, _ components: [Self])
    public var underlyingKey: String {
        switch self { case .type(_, let key), .tuple(_, let key, _), .generic(_, let key, _, _): return key }
    }
    public var underlyingAny: String {
        switch self { case .type(_, let key), .tuple(_, let key, _): return key; case .generic(_, _, let any, _): return any }
    }
    public var underlyingType: Any.Type {
        switch self { case .type(let type, _), .tuple(let type, _, _), .generic(let type, _, _, _): return type }
    }
    public subscript(index: Int) -> Self {
        guard index > -1 else { return self }
        switch self {
        case .type: return self
        case .tuple(_, _, let componets), .generic(_, _, _, let componets): return componets[index] }
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    //: RawRepresentable
    public init?(rawValue: String) {
        self = try! Self.find(forKey: rawValue)
    }
    public var rawValue: String {
        underlyingKey
    }
    
    // MARK: - TypeKey
    public static func typeKey(type value: Any, namespace: String? = nil) -> String {
        typeKey(for: String(reflecting: Swift.type(of: value)), namespace: namespace)
    }
    
    public static func typeKey(for value: Any, namespace: String? = nil) -> String {
        typeKey(for: String(reflecting: value), namespace: namespace)
    }

    public static func typeKey(for value: String, namespace: String? = nil) -> String {
        let key = typeKeyPlatform(for: value)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "Swift.Optional", with: "!")
            .replacingOccurrences(of: "Swift.", with: "#")
            .replacingOccurrences(of: "SwiftUI.", with: ":")
        guard let namespace = namespace else { return key }
        let keyIdx = !key.starts(with: "!<") ? key.startIndex : key.index(key.startIndex, offsetBy: 2)
        let genericIdx = key[keyIdx...].firstIndex(of: "<")
        let baseKey = String(genericIdx == nil ? key[keyIdx...] : key[keyIdx..<genericIdx!])
        let newBaseKey = typeKey(for: "\(namespace)\(baseKey[baseKey.firstIndex(of: ".")!...])")
        return key.replacingOccurrences(of: baseKey, with: newBaseKey)
    }
    
   static func typeKeyPlatform(for value: String) -> String {
        var key = value
        while true {
            guard let idx = key.range(of: "(extension", options: .backwards)?.lowerBound else { return key }
            let idx2 = key[idx...].range(of: "):")!.upperBound
            key.removeSubrange(idx..<idx2)
        }
    }
    
    public static func typeKeyName(for value: String) -> String {
        value.replacingOccurrences(of: "!", with: "SwiftUI.Optional")
            .replacingOccurrences(of: "#", with: "Swift.")
            .replacingOccurrences(of: ":", with: "SwiftUI.")
    }


    // MARK: - Register
    static var knownTypes = [String:Self]()
    static var knownGenerics = [String:(types: [String:Any.Type], anys: [Any.Type?]?)]()
    static var optionalTypes = [ObjectIdentifier:Any.Type]()
    static var convertTypes = [String:Convertible.Type]()
    static var actionTypes = [String:[String:Any]]()
    
    public static func register<T>(_ type: T.Type, any: [Any.Type?]? = nil, namespace: String? = nil, actions: [String:Any]? = nil, alias: String? = nil) {
        let key = typeKey(for: type, namespace: namespace)
        if knownTypes[key] == nil {
            // register
            let typeOptional = Optional<T>.self
            let keyOptional = typeKey(for: typeOptional, namespace: namespace)
            let genericIdx = key.firstIndex(of: "<")
            let baseKey = genericIdx == nil ? key : String(key[..<genericIdx!])
            knownTypes[key] = .type(type, key)
            knownTypes[keyOptional] = .type(typeOptional, keyOptional)
            if alias != nil { knownTypes[alias!] = .type(type, key) }
            optionalTypes[ObjectIdentifier(typeOptional)] = type
            // generic
            if genericIdx != nil {
                let genericKey = baseKey != ":TupleView" ? baseKey : "\(baseKey):\(key.components(separatedBy: ",").count)"
                if knownGenerics[genericKey] == nil { knownGenerics[genericKey] = ([String:T.Type](), any) }
                knownGenerics[genericKey]!.types[any != nil ? key : ""] = type
            }
            // convert
            if let convert = type as? Convertible.Type {
                convertTypes[key] = convert
            }
        }
        
        // actions
        guard let actions = actions else { return }
        guard var set = actionTypes[key] else {
            actionTypes[key] = actions
            return
        }
        for (k, v) in actions {
            set.updateValue(v, forKey: k)
        }
    }
    
    // MARK: - Lookup
    public static func type(for type: Any.Type) throws -> Self {
        let _ = registered
        return try find(forKey: typeKey(for: type))
    }
    
    public static func optional(type: Any.Type) -> Any.Type {
        let _ = registered
        return optionalTypes[ObjectIdentifier(type)] ?? type
    }
    
    public static func convert(value: Any) throws -> Any {
        let _ = registered
        let key = typeKey(for: Swift.type(of: value))
        guard let convert = convertTypes[key] else {
            let any = try find(forKey: key).underlyingAny
            guard let convert2 = convertTypes[any] else {
                fatalError()
            }
            convertTypes[key] = convert2
            return convert2.init(any: value)
        }
        return convert.init(any: value)
    }
    
    // MARK: - Find
    let typeParseTokens_breaks = ["<", "(", ",", ")", ">"]
    private static func typeParse(tokens raw: String) -> [(op: String, value: String)] {
        let name = raw.replacingOccurrences(of: " ", with: "")
        var tokens = [(op: String, value: String)]()
        var nameidx = name.startIndex
        while let idx = name[nameidx...].firstIndex(where: { typeParseTokens_breaks.contains(String($0)) }) {
            if nameidx != idx {
                tokens.append((op: "n", value: String(name[nameidx...name.index(idx, offsetBy: -1)])))
            }
            tokens.append((op: String(name[idx]), value: ""))
            nameidx = name.index(idx, offsetBy: 1)
        }
        if tokens.isEmpty {
            tokens.append((op: "n", value: name))
        }
        return tokens
    }
    
    public static func find<Action>(actionAndType action: String, forKey key: String) throws -> (Action?, Self) {
        (find(action: action, forKey: key), try find(forKey: key))
    }
    
    public static func find<Action>(action: String, forKey key: String) -> Action? {
        actionTypes[key]![action] as? Action
    }

    public static func find(forKey: String) throws -> Self {
        let _ = registered
        if let knownType = knownTypes[forKey] { return knownType }
        let tokens = typeParse(tokens: forKey)
        var typ: Self = .type(Never.self, "Never")
        var key: String = forKey, any: String = ""
        var keys = [String](), anys = [String](), typs = [Self]()
        var stack = [(op: String, value: Any, key: String, any: String)]()
        for token in tokens {
            if token.op != ")" && token.op != ">" {
                stack.append((token.op, token.value, "", ""))
                continue
            }
            var last: (op: String, value: Any, key: String, any: String)
            let lastOp = token.op == ")" ? "(" : token.op == ">" ? "<" : ""
            keys.removeAll(); anys.removeAll(); typs.removeAll()
            keys.append(token.op); anys.append(token.op)
            repeat {
                last = stack.removeLast()
                switch last.op {
                case ",":
                    typs.insert(typ, at: 0)
                    keys.insert(key, at: 0); keys.insert(",", at: 0)
                    anys.insert(any, at: 0); anys.insert(",", at: 0)
                case "t": key = last.key; any = last.any; typ = last.value as! Self
                case "n": key = last.value as! String; any = key; typ = try findTypeStandard(key: key)
                case "(":
                    typs.insert(typ, at: 0)
                    keys.insert(key, at: 0); keys.insert("(", at: 0); key = keys.joined()
                    anys.insert(any, at: 0); anys.insert("(", at: 0); any = anys.joined()
                    stack.append(("t", try findTypeTuple(Any.self, key: key, tuple: typs), key, any))
                case "<":
                    let generic = stack.removeLast(), genericName = generic.value as! String
                    typs.insert(typ, at: 0)
                    keys.insert(key, at: 0); keys.insert("<", at: 0); keys.insert(genericName, at: 0); key = keys.joined()
                    anys.insert(any, at: 0); anys.insert("<", at: 0); anys.insert(genericName, at: 0)
                    if let knownGeneric = knownGenerics[genericName], let genericAnys = knownGeneric.anys {
                        for i in 0..<genericAnys.count {
                            guard let type = genericAnys[i] else { continue }
                            anys[2+(i*2)] = typeKey(for: type)
                        }
                    }
                    any = anys.joined()
                    stack.append(("t", try findTypeGeneric(key: key, any: any, genericName: genericName, generic: typs), key, any))
                case let unrecognized: fatalError(unrecognized)
                }
            } while last.op != lastOp
        }
        guard stack.count == 1, let first = stack.first, first.op == "t" else {
            throw PTypeError.typeParseError(key: key)
        }
        guard forKey == key else {
            throw PTypeError.typeNameError(actual: forKey, expected: key)
        }
        typ = first.value as! Self
        knownTypes[forKey] = typ
        return typ
    }
    
    private static func findTypeStandard(key: String) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        throw PTypeError.typeNotFound(named: key)
    }
    
    private static func findTypeTuple<T>(_ t: T.Type, key: String, tuple: [Self]) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        var type: Any.Type
        switch tuple.count {
        case 02: type = (T, T).Type.self
        case 03: type = (T, T, T).Type.self
        case 04: type = (T, T, T, T).Type.self
        case 05: type = (T, T, T, T, T).Type.self
        case 06: type = (T, T, T, T, T, T).Type.self
        case 07: type = (T, T, T, T, T, T, T).Type.self
        case 08: type = (T, T, T, T, T, T, T, T).Type.self
        case 09: type = (T, T, T, T, T, T, T, T, T).Type.self
        case 10: type = (T, T, T, T, T, T, T, T, T, T).Type.self
        case let unrecognized: fatalError("\(unrecognized)")
        }
        let ptype = .tuple(type, key, tuple)
        knownTypes[key] = ptype
        return ptype
    }
    
    internal static func buildTypeTuple<Element>(tuple dataType: Self, for s: [Element]) -> Any {
        switch s.count {
        case 02: return (s[0], s[1])
        case 03: return (s[0], s[1], s[2])
        case 04: return (s[0], s[1], s[2], s[3])
        case 05: return (s[0], s[1], s[2], s[3], s[4])
        case 06: return (s[0], s[1], s[2], s[3], s[4], s[5])
        case 07: return (s[0], s[1], s[2], s[3], s[4], s[5], s[6])
        case 08: return (s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7])
        case 09: return (s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8])
        case 10: return (s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9])
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
    
    private static func findTypeGeneric(key: String, any: String, genericName: String, generic: [Self]) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        //: use if case
        let first = generic[0]
        let genericKey: String
        switch first {
        case .tuple(_, _, let componets) where genericName == ":TupleView": genericKey = "\(genericName):\(componets.count)"
        default: genericKey = genericName
        }
        // let v = knownGenerics[genericKey] ?? throw PTypeError.typeNotFound(named: key)
        guard let v = knownGenerics[genericKey] else {
            throw PTypeError.typeNotFound(named: key)
        }
        let types = v.types
        // let type = types[any] ?? types[""] ?? throw PTypeError.typeNotFound(named: key)
        guard let type = types[any] ?? types[""] else {
            throw PTypeError.typeNotFound(named: key)
        }
        let ptype = .generic(type, key, any, generic)
        knownTypes[key] = ptype
        return ptype
    }
    
    // MARK: - Register
    public static let registered: Bool = registerDefault()
    
    public static func registerDefault() -> Bool {
        register(Any.self)
        register(Never.self)
        register(String.self)
        register(Int.self)
        register(Bool.self)
        register(Range<Int>.self)
        //: nsobject
        register(NSDate.self, alias: "__NSTaggedDate")
        register(NSURL.self)
        register(Timer.TimerPublisher.self, alias: "Timer.TimerPublisher")
        register(DateFormatter.self)
        //: combine
        register(AnyPublisher<Any, Never>.self)
        register(PassthroughSubject<Any, Never>.self)
        register(CurrentValueSubject<Any, Never>.self)
        return true
    }
}

public struct PTypeWithNil: RawRepresentable {
    public let ptype: PType
    public let hasNil: Bool
    public init(_ ptype: PType, hasNil: Bool) {
        self.ptype = ptype
        self.hasNil = hasNil
    }
    //: RawRepresentable
    public init?(rawValue: String) {
        guard rawValue.hasSuffix(":nil") else {
            ptype = PType(rawValue: rawValue)!
            hasNil = false
            return
        }
        let endIdx = rawValue.lastIndex(of: ":")!
        ptype = PType(rawValue: String(rawValue[..<endIdx]))!
        hasNil = true
    }
    public var rawValue: String {
        !hasNil ? ptype.rawValue : "\(ptype.rawValue):nil"
    }
}
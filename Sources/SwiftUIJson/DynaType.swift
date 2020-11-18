//
//  DataType.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

public enum DynaTypeError: Error {
    case typeNotFound(named: String)
    case typeParseError(key: String)
    case typeNameError(actual: String, expected: String)
    case typeNotCodable(_ mode: String, key: String)
}

public protocol Convertible {
    init(any: Any)
}

public struct DynaTypeWithNil: RawRepresentable {
    public let dynaType: DynaType
    public let hasNil: Bool
    public init(_ dynaType: DynaType, hasNil: Bool) {
        self.dynaType = dynaType
        self.hasNil = hasNil
    }
    //: RawRepresentable
    public init?(rawValue: String) {
        guard rawValue.hasSuffix(":nil") else {
            dynaType = DynaType(rawValue: rawValue)!
            hasNil = false
            return
        }
        let endIdx = rawValue.lastIndex(of: ":")!
        dynaType = DynaType(rawValue: String(rawValue[..<endIdx]))!
        hasNil = true
    }
    public var rawValue: String {
        !hasNil ? dynaType.rawValue : "\(dynaType.rawValue):nil"
    }
}

public enum DynaType: RawRepresentable {
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
    //: RawRepresentable
    public init?(rawValue: String) {
        self = try! Self.find(forKey: rawValue)
    }
    public var rawValue: String {
        underlyingKey
    }
    
    // MARK: - Register
    static var knownTypes = [String:Self]()
    static var knownGenerics = [String:(type: Any.Type, anys: [Any.Type]?)]()
    static var optionalTypes = [ObjectIdentifier:Any.Type]()
    static var convertTypes = [String:Convertible.Type]()
    static var actionTypes = [String:[String:Any]]()
    
    public static func register<T>(_ type: T.Type, any: [Any.Type]? = nil, namespace: String? = nil, actions: [String:Any]? = nil) {
        let key = typeKey(for: type, namespace: namespace)
        if knownTypes[key] == nil {
            // register
            let typeOptional = Optional<T>.self
            let keyOptional = typeKey(for: typeOptional, namespace: namespace)
            let genericIdx = key.firstIndex(of: "<")
            let baseKey = genericIdx == nil ? key : String(key[..<genericIdx!])
            knownTypes[key] = .type(type, key)
            knownTypes[keyOptional] = .type(typeOptional, keyOptional)
            optionalTypes[ObjectIdentifier(typeOptional)] = type
            // generic
            if genericIdx != nil {
                let genericKey = baseKey != ":TupleView" ? baseKey : "\(baseKey):\(key.components(separatedBy: ",").count)"
                if knownGenerics[genericKey] == nil {
                    knownGenerics[genericKey] = (type, any)
                }
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
    
    // MARK: - Parse/Build
    public static func typeKey(type value: Any, namespace: String? = nil) -> String {
        typeKey(for: String(reflecting: Swift.type(of: value)), namespace: namespace)
    }
    public static func typeKey(for value: Any, namespace: String? = nil) -> String {
        typeKey(for: String(reflecting: value), namespace: namespace)
    }
    public static func typeKey(for value: String, namespace: String? = nil) -> String {
        let key = value.split(separator: ":").last!
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
    
    public static func typeName(for value: String) -> String {
        value.replacingOccurrences(of: "!", with: "SwiftUI.Optional")
            .replacingOccurrences(of: "#", with: "Swift.")
            .replacingOccurrences(of: ":", with: "SwiftUI.")
    }
    
    private static func typeParse(tokens raw: String) -> [(op: String, value: String)] {
        let breaks = ["<", "(", ",", ")", ">"]
        let name = raw.replacingOccurrences(of: " ", with: "")
        var tokens = [(op: String, value: String)]()
        var nameidx = name.startIndex
        while let idx = name[nameidx...].firstIndex(where: { breaks.contains(String($0)) }) {
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
        if let type = knownTypes[forKey] { return type }
        let tokens = typeParse(tokens: forKey)
        var type: Self = .type(Never.self, "Never")
        var key: String = "", any: String = ""
        var keyArray = [String](), anyArray = [String](), typeArray = [Self]()
        var stack = [(op: String, value: Any, key: String, any: String)]()
        for token in tokens {
            if token.op == ")" || token.op == ">" {
                var last: (op: String, value: Any, key: String, any: String)
                let lastOp = token.op == ")" ? "(" : token.op == ">" ? "<" : ""
                keyArray.removeAll(); anyArray.removeAll(); typeArray.removeAll()
                keyArray.append(token.op); anyArray.append(token.op)
                repeat {
                    last = stack.removeLast()
                    switch last.op {
                    case ",":
                        typeArray.insert(type, at: 0)
                        keyArray.insert(key, at: 0); keyArray.insert(last.op, at: 0)
                        anyArray.insert(any, at: 0); anyArray.insert(last.op, at: 0)
                    case "t": key = last.key; any = last.any; type = last.value as! Self
                    case "n": key = last.value as! String; any = key; type = try findType(key: key)
                    case "(":
                        typeArray.insert(type, at: 0)
                        keyArray.insert(key, at: 0); keyArray.insert(last.op, at: 0); key = keyArray.joined()
                        anyArray.insert(any, at: 0); anyArray.insert(last.op, at: 0); any = anyArray.joined()
                        stack.append(("t", try findType(key: key, tuple: typeArray), key, any))
                    case "<":
                        let generic = stack.removeLast(), genericName = generic.value as! String
                        typeArray.insert(type, at: 0)
                        keyArray.insert(key, at: 0); keyArray.insert(last.op, at: 0); keyArray.insert(genericName, at: 0); key = keyArray.joined()
                        anyArray.insert(any, at: 0); anyArray.insert(last.op, at: 0); anyArray.insert(genericName, at: 0)
                        if let generic = knownGenerics[genericName], let anys = generic.anys {
                            for i in 0..<anys.count {
                                let type = anys[i]
                                anyArray[2+(i*2)] = type != Operation.self
                                    ? typeKey(for: type)
                                    : ""
                            }
                        }
                        any = anyArray.joined()
                        stack.append(("t", try findType(key: key, any: any, genericName: genericName, generic: typeArray), key, any))
                    case let unrecognized: fatalError(unrecognized)
                    }
                } while last.op != lastOp
            }
            else { stack.append((token.op, token.value, "", "")) }
        }
        guard stack.count == 1, let first = stack.first, first.op == "t" else {
            throw DynaTypeError.typeParseError(key: key)
        }
        guard forKey == key else {
            throw DynaTypeError.typeNameError(actual: key, expected: key)
        }
        type = first.value as! Self
        knownTypes[forKey] = type
        return type
    }
    
    private static func findType(key: String) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        throw DynaTypeError.typeNotFound(named: key)
    }
    
    private static func findType(key: String, tuple: [Self]) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        var type: Any.Type
        switch tuple.count {
        case 01: type = (IAnyView).Type.self
        case 02: type = (IAnyView, IAnyView).Type.self
        case 03: type = (IAnyView, IAnyView, IAnyView).Type.self
        case 04: type = (IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 05: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 06: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 07: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 08: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 09: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case 10: type = (IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView, IAnyView).Type.self
        case let unrecognized: fatalError("\(unrecognized)")
        }
        knownTypes[key] = .tuple(type, key, tuple)
        return knownTypes[key]!
    }
    
    internal static func buildType<Element>(tuple dataType: Self, for s: [Element]) -> Any {
        switch s.count {
        case 01: return (JsonAnyView.any(s[0]))
        case 02: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]))
        case 03: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]))
        case 04: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]))
        case 05: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]))
        case 06: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]),
                         JsonAnyView.any(s[5]))
        case 07: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]),
                         JsonAnyView.any(s[5]), JsonAnyView.any(s[6]))
        case 08: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]),
                         JsonAnyView.any(s[5]), JsonAnyView.any(s[6]), JsonAnyView.any(s[7]))
        case 09: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]),
                         JsonAnyView.any(s[5]), JsonAnyView.any(s[6]), JsonAnyView.any(s[7]), JsonAnyView.any(s[8]))
        case 10: return (JsonAnyView.any(s[0]), JsonAnyView.any(s[1]), JsonAnyView.any(s[2]), JsonAnyView.any(s[3]), JsonAnyView.any(s[4]),
                         JsonAnyView.any(s[5]), JsonAnyView.any(s[6]), JsonAnyView.any(s[7]), JsonAnyView.any(s[8]), JsonAnyView.any(s[9]))
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
    
    private static func findType(key: String, any: String, genericName: String, generic: [Self]) throws -> Self {
        if let knownType = knownTypes[key] { return knownType }
        let genericKey: String
        switch generic[0] {
        case .tuple(_, _, let componets) where genericName == ":TupleView": genericKey = "\(genericName):\(componets.count)"
        default: genericKey = genericName
        }
        guard let v = knownGenerics[genericKey] else {
            throw DynaTypeError.typeNotFound(named: key)
        }
        knownTypes[key] = .generic(v.type, key, any, generic)
        return knownTypes[key]!
    }
    
    // MARK: - Register
    public static let registered: Bool = registerDefault()
    
    public static func registerDefault() -> Bool {
        register(Any.self)
        //        register(Date.self)
        register(String.self)
        register(Int.self)
        register(Bool.self)
        register(Range<Int>.self)
        return true
    }
}

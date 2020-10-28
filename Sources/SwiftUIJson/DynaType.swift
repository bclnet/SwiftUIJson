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

public protocol DynaConvert {
    init(any s: Any)
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
        switch self { case .generic(_, _, let any, _): return any default: fatalError() }
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
        self = try! Self.typeParse(key: rawValue)
    }
    public var rawValue: String {
        underlyingKey
    }

    // MARK: - Register
    static var knownTypes = [String:Self]()
    static var knownGenerics = [String:(type: Any.Type, anys: [Any.Type?]?)]()
    static var unwrapTypes = [ObjectIdentifier:Any.Type]()
    static var convertTypes = [String:DynaConvert.Type]()

    public static func register<T>(_ type: T.Type, any: [Any.Type?]? = nil, namespace: String? = nil) {
        let typeOptional = Optional<T>.self
        var key = typeKey(for: type), keyOptional = typeKey(for: typeOptional)
        let genericIdx = key.firstIndex(of: "<")
        var baseKey = genericIdx == nil ? key : String(key[..<genericIdx!])
        if namespace != nil {
            let newBaseKey = typeKey(for: "\(namespace!)\(baseKey[baseKey.lastIndex(of: ".")!...])")
            key = key.replacingOccurrences(of: baseKey, with: newBaseKey)
            keyOptional = keyOptional.replacingOccurrences(of: baseKey, with: newBaseKey)
            baseKey = newBaseKey
        }
        if let convert = type as? DynaConvert.Type {
            convertTypes[key] = convert
        }
        knownTypes[key] = .type(type, key)
        knownTypes[keyOptional] = .type(typeOptional, keyOptional)
        unwrapTypes[ObjectIdentifier(typeOptional)] = type
        if genericIdx == nil { return }
        let genericKey = baseKey != ":TupleView" ? baseKey : "\(baseKey):\(key.components(separatedBy: ",").count)"
        guard knownGenerics[genericKey] == nil else { fatalError("\(genericKey) is already registered") }
        knownGenerics[genericKey] = (type, any)
    }
    
    // MARK: - Lookup
    public static func type(for type: Any.Type) throws -> Self {
        let _ = registered
        return try typeParse(key: typeKey(for: type))
    }
    
    public static func unwrap(type: Any.Type) -> Any.Type {
        let _ = registered
        return unwrapTypes[ObjectIdentifier(type)] ?? type
    }
    
    public static func convert(value: Any) throws -> Any {
        let _ = registered
        let key = typeKey(for: Swift.type(of: value))
        guard let convert = convertTypes[key] else {
            let any = try typeParse(key: key).underlyingAny
            guard let convert2 = convertTypes[any] else {
                fatalError()
            }
            convertTypes[key] = convert2
            return convert2.init(any: value)
        }
        return convert.init(any: value)
    }
    
    // MARK: - Parse/Build
    public static func typeKey(for value: Any) -> String {
        String(reflecting: value).replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "Swift.", with: "#")
            .replacingOccurrences(of: "SwiftUI.", with: ":")
    }
    public static func typeKey(for value: String) -> String {
        value.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "Swift.", with: "#")
            .replacingOccurrences(of: "SwiftUI.", with: ":")
    }
    
    public static func typeName(for value: String) -> String {
        value.replacingOccurrences(of: "#", with: "Swift.")
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

    private static func typeParse(key forKey: String) throws -> Self {
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
                keyArray.append(token.op); anyArray.append(token.op);
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
                                guard let type = anys[i] else { continue }
                                anyArray[2+(i*2)] = typeKey(for: type)
                            }
                        }
                        any = anyArray.joined()
                        stack.append(("t", try findType(key: key, any: any, genericName: genericName, generic: typeArray), key, any))
                    default: fatalError()
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
        case 01: type = (JsonView).Type.self
        case 02: type = (JsonView, JsonView).Type.self
        case 03: type = (JsonView, JsonView, JsonView).Type.self
        case 04: type = (JsonView, JsonView, JsonView, JsonView).Type.self
        case 05: type = (JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        case 06: type = (JsonView, JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        case 07: type = (JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        case 08: type = (JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        case 09: type = (JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        case 10: type = (JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView, JsonView).Type.self
        default: fatalError()
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
        default: fatalError()
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
        registerDefault_all()
        return true
    }
    
    private static func registerDefault_all() {
//        register(Date.self)
        register(String.self)
        register(Int.self)
        register(Bool.self)
    }
}

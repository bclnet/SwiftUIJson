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
    case typeParseError(named: String)
    case typeNameError(actual: String, expected: String)
    case typeNotCodable(_ mode: String, named: String)
}

public struct DynaTypeWithNil: RawRepresentable, Codable {
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
    //: Codable
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public enum DynaType: RawRepresentable, Codable {
    case type(_ type: Any.Type, _ name: String)
    case tuple(_ type: Any.Type, _ name: String, _ components: [Self])
    case generic(_ type: Any.Type, _ name: String, _ components: [Self])
    public var underlyingName: String {
        switch self { case .type(_, let name), .tuple(_, let name, _), .generic(_, let name, _): return name }
    }
    public var underlyingType: Any.Type {
        switch self { case .type(let type, _), .tuple(let type, _, _), .generic(let type, _, _): return type }
    }
    public subscript(index: Int) -> Self {
        guard index > -1 else { return self }
        switch self {
        case .type: return self
        case .tuple(_, _, let componets), .generic(_, _, let componets): return componets[index] }
    }
    //: RawRepresentable
    public init?(rawValue: String) {
        self = try! Self.typeParse(for: rawValue)
    }
    public var rawValue: String {
        Self.typeName(for: underlyingName)
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    // MARK: - Register
    static var knownTypes = [String:Self]()
    static var knownGenerics = [String:Any.Type]()
    static var unwrapTypes = [ObjectIdentifier:Any.Type]()
    
    public static func register<T>(_ type: T.Type) {
        let typeOptional = Optional<T>.self
        let knownName = String(reflecting: type), knownNameOptional = String(reflecting: typeOptional)
        knownTypes[knownName] = .type(type, knownName)
        knownTypes[knownNameOptional] = .type(typeOptional, knownNameOptional)
        unwrapTypes[ObjectIdentifier(typeOptional)] = type
        let parts = knownName.components(separatedBy: "<"); if parts.count == 1 { return }
        let genericName = parts[0], genericKey = !knownName.starts(with: "SwiftUI.TupleView<(") ? genericName  : "\(genericName):\(knownName.components(separatedBy: ",").count)"
        guard knownGenerics[genericKey] == nil else { fatalError("\(genericKey) is already registered") }
        knownGenerics[genericKey] = type
    }
    
    // MARK: - Lookup
    public static func type(for type: Any.Type) throws -> Self {
        let _ = registered
        return try typeParse(for: typeName(for: String(reflecting: type)))
    }
    
    public static func unwrap(type: Any.Type) -> Any.Type {
        let _ = registered
        return unwrapTypes[ObjectIdentifier(type)] ?? type
    }
    
    // MARK: - Parse/Build
    private static func typeName(for typeName: String) -> String! {
        typeName.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "Swift.", with: "#")
            .replacingOccurrences(of: "SwiftUI.", with: ":")
    }

    private static func typeParse(for name: String) throws -> Self {
        let _ = registered
        let forName = name
            .replacingOccurrences(of: "#", with: "Swift.")
            .replacingOccurrences(of: ":", with: "SwiftUI.")
            
        if let knownType = knownTypes[forName] { return knownType }
        let tokens = typeParse(tokens: forName)
        var knownType: Self = .type(Never.self, "Never")
        var knownName: String = ""
        var nameArray = [String]()
        var typeArray = [Self]()
        var stack = [(op: String, value: Any, knownName: String)]()
        for token in tokens {
            if token.op == ")" || token.op == ">" {
                var last: (op: String, value: Any, knownName: String)
                let lastOp = token.op == ")" ? "(" : token.op == ">" ? "<" : ""
                nameArray.removeAll(); nameArray.append(token.op); typeArray.removeAll()
                repeat {
                    last = stack.removeLast()
                    switch last.op {
                    case ",": nameArray.insert(knownName, at: 0); nameArray.insert(last.op, at: 0); typeArray.insert(knownType, at: 0)
                    case "n": knownName = last.value as! String; knownType = try typeParse(knownName: knownName)
                    case "t": knownName = last.knownName; knownType = last.value as! Self
                    case "(":
                        nameArray.insert(knownName, at: 0); nameArray.insert(last.op, at: 0); typeArray.insert(knownType, at: 0)
                        knownName = nameArray.joined()
                        stack.append(("t", try typeParse(knownName: knownName, tuple: typeArray), knownName))
                    case "<":
                        let generic = stack.removeLast(), genericName = generic.value as! String
                        nameArray.insert(knownName, at: 0); nameArray.insert(last.op, at: 0); nameArray.insert(genericName, at: 0); typeArray.insert(knownType, at: 0)
                        knownName = nameArray.joined()
                        stack.append(("t", try typeParse(knownName: knownName, genericName: genericName, generic: typeArray), knownName))
                    default: fatalError()
                    }
                } while last.op != lastOp
            }
            else { stack.append((token.op, token.value, "")) }
        }
        guard stack.count == 1, let first = stack.first, first.op == "t" else {
            throw DynaTypeError.typeParseError(named: forName)
        }
        guard forName == knownName else {
            throw DynaTypeError.typeNameError(actual: forName, expected: knownName)
        }
        knownType = first.value as! Self
        knownTypes[name] = knownType
        return knownType
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
    
    private static func typeParse(knownName: String) throws -> Self {
        if let knownType = knownTypes[knownName] { return knownType }
        throw DynaTypeError.typeNotFound(named: knownName)
    }
    
    private static func typeParse(knownName: String, tuple: [Self]) throws -> Self {
        if let knownType = knownTypes[knownName] { return knownType }
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
        knownTypes[knownName] = .tuple(type, knownName, tuple)
        return knownTypes[knownName]!
    }
    
    internal static func typeBuildTuple<Element>(_ dataType: Self, for s: [Element]) -> Any {
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
    
    private static func typeParse(knownName: String, genericName: String, generic: [Self]) throws -> Self {
        if let knownType = knownTypes[knownName] { return knownType }
        let genericKey: String
        switch generic[0] {
        case .tuple(_, _, let componets) where genericName == "SwiftUI.TupleView": genericKey = "\(genericName):\(componets.count)"
        default: genericKey = genericName
        }
        guard let type = knownGenerics[genericKey] else { throw DynaTypeError.typeNotFound(named: knownName) }
        knownTypes[knownName] = .generic(type, knownName, generic)
        return knownTypes[knownName]!
    }
    
    //    public func typeBind<T, Element>(to type: T.Type, for source: [Element]) -> T {
    //        let abc = T.self
    //        switch self {
    //        case .type:
    //            return source.withUnsafeBytes { $0.bindMemory(to: T.self)[0] }
    //        case .tuple(let type, _, let componets):
    //            return source.withUnsafeBytes { $0.bindMemory(to: T.self)[0] }
    //        case .generic(let type, _, let componets):
    //            return source.withUnsafeBytes { $0.bindMemory(to: T.self)[0] }
    //        }
    //    }
    
    // MARK: - Register
    public static let registered: Bool = registerDefault()
    
    public static func registerDefault() -> Bool {
        registerDefault_all()
        return true
    }
    
    private static func registerDefault_all() {
        register(Date.self)
        register(String.self)
        register(Int.self)
    }
}

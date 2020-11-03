//
//  Extensions.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension View {
//    func dump() -> some View {
//        let context = JsonContext[self]
//        let data = try! JsonUI.encode(view: self.body, context: context)
//        print(String(data: data, encoding: .utf8)!)
//        return self
//    }
//}

//public protocol OptionalType: ExpressibleByNilLiteral {
//    associatedtype WrappedType
//    var asOptional: WrappedType? { get }
//}
//
//extension Optional: OptionalType {
//    public var asOptional: Wrapped? {
//        return self
//    }
//}

extension Mirror {
    enum KeyMatch {
        case all, any
    }
    static func assert(_ any: Any, name: String, keys: [String]? = nil, keyMatch: KeyMatch = .all) {
        let m = Mirror(reflecting: any)
        let anyName = String("\(type(of: any))".split(separator: "<")[0])
        Swift.assert(name == anyName)
        var matchKeys = Set(m.children.map { $0.label! })
        if let keys = keys {
            var unmatchKeys = Set<String>()
            for k in keys {
                let s = k.components(separatedBy: ".")
                if matchKeys.remove(s[0]) == nil, !keys.contains(s[0]) { unmatchKeys.insert(s[0])}
                if s.count == 1 { continue }
                var d = any
                for i in 0..<s.count {
                    d = Mirror(reflecting: d).descendant(s[i])!
                }
            }
            switch keyMatch {
            case .all: Swift.assert(matchKeys.isEmpty && unmatchKeys.isEmpty)
            case .any: Swift.assert(unmatchKeys.isEmpty)
            }
        }
    }
    static func unwrap(value: Any) -> Any {
        if case Optional<Any>.some(let wrapped) = value { return wrapped }
        return value
    }
    static func isOptional(_ value: Any) -> Bool {
        Mirror(reflecting: value).displayStyle == .optional
    }
    static func values(reflecting: Any) -> [Any] {
        Mirror(reflecting: reflecting).children.map({ $0.value })
    }
    static func children(reflecting: Any) -> [String:Any] {
        Mirror(reflecting: reflecting).children.reduce(into: [String:Any]()) { $0[$1.label!] = $1.value }
    }
    static func single(reflecting: Any, named: String? = nil) -> Mirror.Child {
        let children = Mirror(reflecting: reflecting).children
        guard children.count == 1, let first = children.first, named == nil || first.label == named else { fatalError("single") }
        return first
    }
}

extension Dictionary where Key == String, Value:Any {
    func child(named: String) -> Mirror.Child {
        Mirror(reflecting: self[named]!).children.first!
    }
    func children(named: String) -> Mirror.Children {
        Mirror(reflecting: self[named]!).children
    }
}

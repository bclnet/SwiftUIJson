//
//  Extensions.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Mirror {
    static func values(reflecting: Any) -> [Any] {
        Mirror(reflecting: reflecting).children.map({ $0.value })
    }
//    static func set(reflecting: Any) -> [(String, Any)] {
//        Mirror(reflecting: reflecting).children.map({ ($0.label!, $0.value) })
//    }
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

//
//  AnyView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol IAnyView {
    var anyView: AnyView { get }
}

extension AnyView: DynaCodable {
//    static func unwrap(any: Any) -> Any {
//        guard let anyView = any as? AnyView else { return any }
//        Mirror.assert(any, name: "AnyView", keys: ["storage"])
//        let storage = AnyViewStorage(any: Mirror(reflecting: anyView).descendant("storage")!)
//        return storage.view
//    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        guard let context = decoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        let view = try context.dynaSuperInit(from: decoder, for: dynaType) as! IAnyView
        self = view.anyView
    }
    public func encode(to encoder: Encoder) throws {
        guard let context = encoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        Mirror.assert(self, name: "AnyView", keys: ["storage"])
        let storage = AnyViewStorage(any: Mirror(reflecting: self).descendant("storage")!)
        try context.encodeDynaSuper(storage.view, to: encoder)
    }
    //: Register
    static func register() {
        DynaType.register(AnyView.self)
    }
    
    internal class AnyViewStorage {
        let view: Any
        init(any: Any) {
            Mirror.assert(any, name: "AnyViewStorage", keys: ["view"])
            view = Mirror(reflecting: any).descendant("view")!
        }
    }
}

public struct JsonAnyView: View {
    public let body: AnyView
    public init(_ view: IAnyView) {
        body = view.anyView
    }
    static func any<Element>(_ value: Element) -> JsonAnyView {
        JsonAnyView(value as? IAnyView ?? EmptyView())
    }
}

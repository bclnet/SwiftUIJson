//
//  AnyView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol JsonView {
    var anyView: AnyView { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyView: DynaCodable {
    static func unwrap(value: Any) -> Any {
        guard let anyView = value as? AnyView else { return value }
        let storage = AnyViewStorageBase(any: Mirror(reflecting: anyView).descendant("storage")!)
        return storage.view
    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let view = try decoder.dynaSuperInit(for: dynaType[0]) as! JsonView
        self = view.anyView
    }
    public func encode(to encoder: Encoder) throws {
        let storage = AnyViewStorageBase(any: Mirror(reflecting: self).descendant("storage")!)
        try encoder.encodeDynaSuper(storage.view)
    }
    //: Register
    static func register() {
        DynaType.register(AnyView.self)
    }
    
    internal class AnyViewStorageBase {
        let view: Any
        init(any s: Any) {
            view = Mirror(reflecting: s).descendant("view")!
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct JsonAnyView: View {
    public let body: AnyView
    public init(_ view: JsonView) {
        body = view.anyView
    }
    static func any<Element>(_ value: Element) -> JsonAnyView {
        JsonAnyView(value as? JsonView ?? EmptyView())
    }
}

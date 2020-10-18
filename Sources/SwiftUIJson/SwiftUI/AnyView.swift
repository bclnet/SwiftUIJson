//
//  AnyView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AnyView: DynaCodable {
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        guard let value = try decoder.dynaSuperInit(for: dynaType[0], depth: depth) as? JsonView else { fatalError("AnyView") }
        self = value.anyView
    }
    public func encode(to encoder: Encoder) throws {
        let single = Mirror(reflecting: self).descendant("storage")!
        let storage = AnyViewStorageBase(any: single)
        try encoder.encodeDynaSuper(storage.view)
    }
    
    internal class AnyViewStorageBase {
        let view: Any
        init(any s: Any) { view = Mirror(reflecting: s).descendant("view")! }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct JsonAnyView: View {
    public let body: AnyView
    public init(_ view: JsonView) { body = view.anyView }
    static func any<Element>(_ value: Element) -> JsonAnyView {
        JsonAnyView(value as? JsonView ?? EmptyView())
    }
}

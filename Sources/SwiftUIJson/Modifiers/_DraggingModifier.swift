//
//  _DraggingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _DraggingModifier: JsonViewModifier, ConvertibleCodable {
    func body(content: AnyView) -> AnyView { fatalError("Not Supported") }
    let itemsForDragHandler: Any
    public init(any: Any) {
        Mirror.assert(any, name: "_DraggingModifier", keys: ["itemsForDragHandler"])
        itemsForDragHandler = Mirror(reflecting: any).descendant("itemsForDragHandler")!
    }

    //: Codable
    public func encode(to encoder: Encoder) throws { fatalError("Not Supported") }
    public init(from decoder: Decoder) throws { fatalError("Not Supported") }

    //: Register
    static func register() {
        PType.register(_DraggingModifier.self, namespace: "SwiftUI")
    }
}

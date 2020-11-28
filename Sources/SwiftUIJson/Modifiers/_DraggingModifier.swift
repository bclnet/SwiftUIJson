//
//  _DraggingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _DraggingModifier: JsonViewModifier, ConvertibleCodable {
    let itemsForDragHandler: Any
    public init(any: Any) {
        Mirror.assert(any, name: "_DraggingModifier", keys: ["itemsForDragHandler"])
        itemsForDragHandler = Mirror(reflecting: any).descendant("itemsForDragHandler")!
    }
    //: JsonViewModifier
    func body(content: AnyView) -> AnyView { fatalError("Not Supported") }
    //: Codable
    public init(from decoder: Decoder) throws { fatalError("Not Supported") }
    public func encode(to encoder: Encoder) throws { fatalError("Not Supported") }
    //: Register
    static func register() {
        DynaType.register(_DraggingModifier.self, namespace: "SwiftUI")
    }
}

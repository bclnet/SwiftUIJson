//
//  _DraggingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct DraggingItem {
    
}

//func anyFunc<T:Sequence>(_ closure: () -> T) {
//    let result: T = closure()
//    for i in result {
//        print(i)
//    }
//}

struct _DraggingModifier: JsonViewModifier, DynaConvertedCodable {
    let itemsForDragHandler: Any
    public init(any: Any) {
        itemsForDragHandler = Mirror(reflecting: any).descendant("itemsForDragHandler")!// as! () -> [DraggingItem]
//        anyFunc(itemsForDragHandler)
    }
    //: JsonViewModifier
    func body(content: AnyView) -> AnyView {
        fatalError()
//        AnyView(content.onDrag(itemsForDragHandler))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case items
    }
    public init(from decoder: Decoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }
    //: Register
    static func register() {
        DynaType.register(_DraggingModifier.self, namespace: "SwiftUI")
    }
}

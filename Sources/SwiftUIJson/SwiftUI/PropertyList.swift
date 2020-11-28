//
//  PropertyList.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct PropertyList<ViewTypeDescription, ActionsKey> where ViewTypeDescription : Convertible {
    let elements: Element?
    init(any: Any) {
        Mirror.assert(any, name: "PropertyList", keys: ["elements"])
        guard let elements = Mirror.optional(any: Mirror(reflecting: any).descendant("elements")!) else { self.elements = nil; return }
        switch String(describing: type(of: elements)) {
        case "TypedElement<ViewTypeDescription>":
            let value = Mirror.optional(any: Mirror(reflecting: elements).descendant("value")!)
            let valueType = String(describing: type(of: value!))
            if valueType == String(describing: ViewTypeDescription.self) { self.elements = TypedElement(any: elements) }
            else { fatalError(valueType) }
        case let unrecognized: fatalError(unrecognized)
        }
    }

    class Element {}
    
    class TypedElement: Element {
        let value: ViewTypeDescription?
        init(any: Any) {
            Mirror.assert(any, name: "TypedElement", keys: ["value"])
            value = Mirror.optionalAny(ViewTypeDescription.self, any: Mirror(reflecting: any).descendant("value")!)
        }
    }
}

class AXAnyViewTypeDescribingBox {}

class AXViewTypeDescribingBox<Content>: AXAnyViewTypeDescribingBox, Convertible where Content : View {
    required init(any: Any) {
        Mirror.assert(any, name: "AXViewTypeDescribingBox", keys: [])
    }
}

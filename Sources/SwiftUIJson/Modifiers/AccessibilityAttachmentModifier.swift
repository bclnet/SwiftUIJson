//
//  AccessibilityAttachmentModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI


struct PropertyList {
    var elements: TypedElement?
    init(any: Any) {
        Mirror.assert(any, name: "PropertyList", keys: ["elements"])
        elements = TypedElement(any: Mirror.unwrap(value: Mirror(reflecting: any).descendant("elements")!))
    }

    class TypedElement {
        let value: Any
        init(any: Any) {
            Mirror.assert(any, name: "TypedElement", keys: ["value"])
            value = Mirror(reflecting: any).descendant("value")!
        }
    }
    
    class Tracker {
    }
}

struct AccessibilityProperties {
    let plist: PropertyList
    public init(any: Any) {
        Mirror.assert(any, name: "AccessibilityProperties", keys: ["plist"])
        plist = PropertyList(any: Mirror(reflecting: any).descendant("plist")!)
    }
}

struct AccessibilityAttachment {
    let properties: AccessibilityProperties
    public init(any: Any) {
        Mirror.assert(any, name: "AccessibilityAttachment", keys: ["properties"])
        properties = AccessibilityProperties(any: Mirror(reflecting: any).descendant("properties")!)
    }
}

struct AccessibilityAttachmentModifier: JsonViewModifier, DynaConvertedCodable {
    let attachment: AccessibilityAttachment?
    let onlyApplyToFirstNode: Bool
    public init(any: Any) {
        Mirror.assert(any, name: "AccessibilityAttachmentModifier", keys: ["attachment", "onlyApplyToFirstNode"])
        let m = Mirror.children(reflecting: any)
        let a = Mirror.unwrap(value: m["attachment"]!)
        attachment = AccessibilityAttachment(any: a)
        onlyApplyToFirstNode = m["onlyApplyToFirstNode"]! as! Bool
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
        DynaType.register(AccessibilityAttachmentModifier.self, namespace: "SwiftUI")
    }
}

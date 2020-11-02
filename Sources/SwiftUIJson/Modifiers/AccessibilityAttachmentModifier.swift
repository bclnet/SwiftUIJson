//
//  AccessibilityAttachmentModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI


struct PropertyList: CustomStringConvertible {
    var description: String { "" }
    var elements: Element?
    init(any: Any) {
        elements = Element(any: Mirror.unwrap(value: Mirror(reflecting: any).descendant("elements")!))
    }

    class Element: CustomStringConvertible {
        var description: String { "" }
        init(any: Any) {
            let abc = Mirror.children(reflecting: any)
        }
    }
    
    class Tracker {
    }
}



struct AccessibilityProperties {
    let plist: PropertyList
    public init(any: Any) {
        plist = PropertyList(any: Mirror(reflecting: any).descendant("plist")!)
    }
}

struct AccessibilityAttachment {
    let properties: AccessibilityProperties
    public init(any: Any) {
        properties = AccessibilityProperties(any: Mirror(reflecting: any).descendant("properties")!)
    }
}

struct AccessibilityAttachmentModifier: JsonViewModifier, DynaConvertedCodable {
    let attachment: AccessibilityAttachment?
    let onlyApplyToFirstNode: Bool
    public init(any: Any) {
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

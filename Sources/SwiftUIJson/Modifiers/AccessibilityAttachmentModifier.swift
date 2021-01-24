//
//  AccessibilityAttachmentModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension AccessibilityAttachmentModifier: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case action
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "AccessibilityAttachmentModifier", keys: ["attachment", "onlyApplyToFirstNode"])
        let m = Mirror.children(reflecting: self)
        let _ = Mirror.optionalAny(AccessibilityAttachment.self, any: m["attachment"]!)
//        let onlyApplyToFirstNode = m["onlyApplyToFirstNode"]! as! Bool
        var container = encoder.container(keyedBy: CodingKeys.self)
        let action: () -> Void = { }
        try container.encodeAction(action, forKey: .action)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let action = try container.decodeAction(forKey: .action)
        //        let abc = Capsule().accessibilityAction(.default) { print("handler") } as! Self
        //        self = (Capsule().accessibilityAction(.default) { print("handler") } as! ModifiedContent<Capsule, AccessibilityAttachmentModifier>).modifier
        self = (Capsule().accessibilityAction(.default, action)).modifier
    }

    //: Register
    static func register() {
        PType.register(AccessibilityAttachmentModifier.self)
    }
}

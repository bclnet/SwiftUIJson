//
//  AddGestureModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct AddGestureModifier<Gesture>: JsonViewModifier, ConvertibleDynaCodable {
    let gestureMask: GestureMask
    let gesture: Gesture
    let action: ((AnyView, GestureMask, Any) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "AddGestureModifier", keys: ["gestureMask", "gesture"])
        let m = Mirror.children(reflecting: any)
        gestureMask = m["gestureMask"]! as! GestureMask
        gesture = m["gesture"]! as! Gesture
        action = nil
    }
    
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { action(AnyView(content), gestureMask, gesture) }

    //: Codable
    enum CodingKeys: CodingKey {
        case gestureMask, gesture
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gestureMask, forKey: .gestureMask)
        try container.encodeAny(gesture, forKey: .gesture)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gestureMask = try container.decode(GestureMask.self, forKey: .gestureMask)
        gesture = try container.decodeAny(Gesture.self, forKey: .gesture, ptype: ptype[0])
        action = PType.find(action: "longPressGesture", forKey: ptype.underlyingAny)
    }

    //: Register
    static func register() {
        PType.register(AddGestureModifier<Any>.self, any: [Any.self], namespace: "SwiftUI", actions: [
                            "longPressGesture": { (view: AnyView, mask: GestureMask, gesture: Any) -> AnyView in
                                let g = gesture as! ModifierGesture<Any, Any>
                                let modifier = g.modifier as! CallbacksGesture<Any>
                                let callbacks = modifier.callbacks as! PressableGestureCallbacks<Any>
                                let content = g.content as! LongPressGesture
                                return AnyView(view.onLongPressGesture(minimumDuration: content.minimumDuration,
                                                                       maximumDistance: content.maximumDistance,
                                                                       pressing: callbacks.pressing,
                                                                       perform: callbacks.pressed)) }])
    }
}

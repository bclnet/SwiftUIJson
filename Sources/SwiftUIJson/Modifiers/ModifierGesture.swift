//
//  CallbackGesture.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct AddGestureModifier<Gesture>: JsonViewModifier, DynaConvertedDynaCodable {
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
    public func body(content: AnyView) -> AnyView {
        action(AnyView(content), gestureMask, gesture)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case gestureMask, gesture
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gestureMask = try container.decode(GestureMask.self, forKey: .gestureMask)
        gesture = try container.decodeAny(Gesture.self, forKey: .gesture, dynaType: dynaType[0])
        action = DynaType.find(action: "longPressGesture", forKey: dynaType.underlyingAny)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gestureMask, forKey: .gestureMask)
        try container.encodeAny(gesture, forKey: .gesture)
    }
}

struct ModifierGesture<Modifier, Content>: DynaConvertedDynaCodable {
    let modifier: Modifier
    let content: Content
    public init(any: Any) {
        Mirror.assert(any, name: "ModifierGesture", keys: ["modifier", "content"])
        let m = Mirror.children(reflecting: any)
        modifier = m["modifier"]! as! Modifier
        content = m["content"]! as! Content
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case modifier, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modifier = try container.decodeAny(Modifier.self, forKey: .modifier, dynaType: dynaType[0])
        content = try container.decodeAny(Content.self, forKey: .content, dynaType: dynaType[1])
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(modifier, forKey: .modifier)
        try container.encodeAny(content, forKey: .content)
    }
    //: Register
    static func register() {
        // MARK: - Gesture:17256
        DynaType.register(CallbacksGesture<Any>.self, any: [Any.self], namespace: "SwiftUI")
        DynaType.register(PressableGestureCallbacks<Any>.self, any: [Any.self], namespace: "SwiftUI")
        DynaType.register(LongPressGesture.self)
        DynaType.register(ModifierGesture<Any, Any>.self, any: [Any.self, Any.self], namespace: "SwiftUI")
        DynaType.register(AddGestureModifier<Any>.self, any: [Any.self], namespace: "SwiftUI", actions: [
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

struct CallbacksGesture<Callbacks>: DynaConvertedDynaCodable {
    let callbacks: Callbacks
    public init(any: Any) {
        Mirror.assert(any, name: "CallbacksGesture", keys: ["callbacks"])
        callbacks = Mirror(reflecting: any).descendant("callbacks")! as! Callbacks
    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        var container = try decoder.unkeyedContainer()
        callbacks = try container.decodeAny(Callbacks.self, dynaType: dynaType[0])
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encodeAny(callbacks)
    }
}

struct PressableGestureCallbacks<Gesture>: DynaConvertedCodable {
    let pressing: ((Bool) -> ())?
    let pressed: () -> ()
    public init(any: Any) {
        Mirror.assert(any, name: "PressableGestureCallbacks", keys: ["pressing", "pressed"])
        let m = Mirror.children(reflecting: any)
        pressing = m["pressing"]! as? ((Bool) -> ())
        pressed = m["pressed"]! as! (() -> ())
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case modifier, content
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        pressing = nil //TODO:
        pressed = { print("HERE") } //TODO:
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GestureMask: Codable {
    public static let allCases: [Self] = [.all, .none, .gesture, .subviews]
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "all": self = .all; return
            case "none": self = .none; return
            case "gesture": elements.insert(.gesture)
            case "subviews": elements.insert(.subviews)
            case let unrecognized: self.init(rawValue: RawValue(unrecognized)!); return
            }
        }
        self = elements
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch self {
                case .all: try container.encode("all"); return
                case .none: try container.encode("none"); return
                case .gesture: try container.encode("gesture")
                case .subviews: try container.encode("subviews")
                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
extension LongPressGesture: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case minimumDuration, maximumDistance
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let minimumDuration = try container.decodeIfPresent(Double.self, forKey: .minimumDuration) ?? 0.5
        let maximumDistance = try container.decodeIfPresent(CGFloat.self, forKey: .maximumDistance) ?? 10
        self.init(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if minimumDuration != 0.5 { try container.encode(minimumDuration, forKey: .minimumDuration) }
        if maximumDistance != 10 { try container.encode(maximumDistance, forKey: .maximumDistance) }
    }
}

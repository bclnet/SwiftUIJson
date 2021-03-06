//
//  ModifierGesture.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct ModifierGesture<Modifier, Content>: ConvertibleDynaCodable {
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
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(modifier, forKey: .modifier)
        try container.encodeAny(content, forKey: .content)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modifier = try container.decodeAny(Modifier.self, forKey: .modifier, ptype: ptype[0])
        content = try container.decodeAny(Content.self, forKey: .content, ptype: ptype[1])
    }

    //: Register
    static func register() {
        PType.register(CallbacksGesture<Any>.self, any: [Any.self], namespace: "SwiftUI")
        PType.register(PressableGestureCallbacks<Any>.self, any: [Any.self], namespace: "SwiftUI")
        PType.register(LongPressGesture.self)
        PType.register(ModifierGesture<Any, Any>.self, any: [Any.self, Any.self], namespace: "SwiftUI")
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

struct CallbacksGesture<Callbacks>: ConvertibleDynaCodable {
    let callbacks: Callbacks
    public init(any: Any) {
        Mirror.assert(any, name: "CallbacksGesture", keys: ["callbacks"])
        callbacks = Mirror(reflecting: any).descendant("callbacks")! as! Callbacks
    }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encodeAny(callbacks)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        var container = try decoder.unkeyedContainer()
        callbacks = try container.decodeAny(Callbacks.self, ptype: ptype[0])
    }
}

struct PressableGestureCallbacks<Gesture>: ConvertibleCodable {
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
        case pressing, pressed
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeActionIfPresent(pressing, forKey: .pressing)
        try container.encodeAction(pressed, forKey: .pressed)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pressing = try container.decodeActionIfPresent(Bool.self, forKey: .pressing)
        pressed = try container.decodeAction(forKey: .pressed)
    }
}

extension GestureMask: Codable {
    public static let allCases: [Self] = [.all, .none, .gesture, .subviews]

    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .all: try container.encode("all"); return
                case .none: try container.encode("none"); return
                case .gesture: try container.encode("gesture")
                case .subviews: try container.encode("subviews")
                case let value: fatalError("\(value)")
//                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "all": self = .all; return
            case "none": self = .none; return
            case "gesture": elements.insert(.gesture)
            case "subviews": elements.insert(.subviews)
            case let value: self.init(rawValue: RawValue(value)!); return
            }
        }
        self = elements
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
extension LongPressGesture: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case minimumDuration, maximumDistance
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if minimumDuration != 0.5 { try container.encode(minimumDuration, forKey: .minimumDuration) }
        if maximumDistance != 10 { try container.encode(maximumDistance, forKey: .maximumDistance) }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let minimumDuration = (try? container.decodeIfPresent(Double.self, forKey: .minimumDuration)) ?? 0.5
        let maximumDistance = (try? container.decodeIfPresent(CGFloat.self, forKey: .maximumDistance)) ?? 10
        self.init(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
    }
}

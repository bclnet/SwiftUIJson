//
//  CallbackGesture.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct AddGestureModifier<Gesture>: DynaConvert, Codable {
    let gestureMask: GestureMask
    let gesture: Gesture
    public init(any: Any) {
        let m = Mirror.children(reflecting: any)
        gestureMask = m["gestureMask"]! as! GestureMask
        gesture = m["gesture"]! as! Gesture
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case gestureMask, gesture
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gestureMask = try container.decode(GestureMask.self, forKey: .gestureMask)
        gesture = try container.decodeAny(Gesture.self, forKey: .gesture)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gestureMask, forKey: .gestureMask)
        try container.encodeAny(gesture, forKey: .gesture)
    }
}

struct ModifierGesture<Modifier, Content>: DynaConvert, Codable {
    let modifier: Modifier
    let content: Content
    public init(any: Any) {
        let m = Mirror.children(reflecting: any)
        modifier = m["modifier"]! as! Modifier
        content = m["content"]! as! Content
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case modifier, content
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modifier = try container.decodeAny(Modifier.self, forKey: .modifier)
        content = try container.decodeAny(Content.self, forKey: .content)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(modifier, forKey: .modifier)
        try container.encodeAny(content, forKey: .content)
    }
}

struct CallbacksGesture<Callbacks>: DynaConvert, Codable {
    let callbacks: Callbacks
    public init(any: Any) {
        callbacks = Mirror(reflecting: any).descendant("callbacks")! as! Callbacks
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        callbacks = try container.decodeAny(Callbacks.self)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encodeAny(callbacks)
    }
}

struct PressableGestureCallbacks<Gesture>: DynaConvert, Codable {
    let pressing: ((Bool) -> ())?
    let pressed: ((Bool) -> ())?
    public init(any: Any) {
        let m = Mirror.children(reflecting: any)
        pressing = m["pressing"]! as? ((Bool) -> ())
        pressed = m["pressed"]! as? ((Bool) -> ())
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case modifier, content
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        pressing = nil //TODO:
        pressed = nil //TODO:
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GestureMask: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(UInt32.self))
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
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

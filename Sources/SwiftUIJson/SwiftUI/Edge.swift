//
//  Edge.swift (Incomplete)
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Edge: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "top": self = .top
        case "leading": self = .leading
        case "bottom": self = .bottom
        case "trailing": self = .trailing
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Edge")
        var container = encoder.singleValueContainer()
        switch self {
        case .top: try container.encode("top")
        case .leading: try container.encode("leading")
        case .bottom: try container.encode("bottom")
        case .trailing: try container.encode("trailing")
        }
    }
}

extension Edge.Set: CaseIterable, Codable {
    public static let allCases: [Self] = [.all, .top, .leading, .bottom, .trailing, .horizontal, .vertical]
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "all": self = .all; return
            case "top": elements.insert(.top)
            case "leading": elements.insert(.leading)
            case "bottom": elements.insert(.bottom)
            case "trailing": elements.insert(.trailing)
            case "horizontal": elements.insert(.horizontal)
            case "vertical": elements.insert(.vertical)
            case let unrecognized: self.init(rawValue: RawValue(unrecognized)!); return
            }
        }
        self = elements
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Set")
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .all: try container.encode("all"); return
                case .top: try container.encode("top")
                case .leading: try container.encode("leading")
                case .bottom: try container.encode("bottom")
                case .trailing: try container.encode("trailing")
                case .horizontal: try container.encode("horizontal")
                case .vertical: try container.encode("vertical")
                case let unrecognized: fatalError("\(unrecognized)")
//                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
}

extension EdgeInsets: Codable {
    var isEmpty: Bool {
        top == 0 && leading == 0 && bottom == 0 && trailing == 0
    }
    var isEqual: Bool {
        top == leading && leading == bottom && bottom == trailing
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case top, leading, bottom, trailing
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let top = try container.decodeIfPresent(CGFloat.self, forKey: .top) ?? 0
        let leading = try container.decodeIfPresent(CGFloat.self, forKey: .leading) ?? 0
        let bottom = try container.decodeIfPresent(CGFloat.self, forKey: .bottom) ?? 0
        let trailing = try container.decodeIfPresent(CGFloat.self, forKey: .trailing) ?? 0
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "EdgeInsets")
        var container = encoder.container(keyedBy: CodingKeys.self)
        if top != 0 { try container.encode(top, forKey: .top) }
        if leading != 0 { try container.encode(leading, forKey: .leading) }
        if bottom != 0 { try container.encode(bottom, forKey: .bottom) }
        if trailing != 0 { try container.encode(trailing, forKey: .trailing) }
    }
}

//(Incomplete)
//extension EdgeInsets {
//
//    /// Create edge insets from the equivalent NSDirectionalEdgeInsets.
//    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
//    @available(watchOS, unavailable)
//    public init(_ nsEdgeInsets: NSDirectionalEdgeInsets)
//}

//(Incomplete)
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension EdgeInsets : Animatable {
//
//    /// The type defining the data to animate.
//    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>
//
//    /// The data to animate.
//    public var animatableData: EdgeInsets.AnimatableData
//}

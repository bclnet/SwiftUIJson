//
//  Edge.swift (Incomplete)
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "top": self = .top
        case "leading": self = .leading
        case "bottom": self = .bottom
        case "trailing": self = .trailing
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .top: try container.encode("top")
        case .leading: try container.encode("leading")
        case .bottom: try container.encode("bottom")
        case .trailing: try container.encode("trailing")
        }
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Edge.Set: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(Int8.self))
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets: Codable {
    public var isEmpty: Bool {
        top == 0 && leading == 0 && bottom == 0 && trailing == 0
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
        var container = encoder.container(keyedBy: CodingKeys.self)
        if top != 0 { try container.encode(top, forKey: .top) }
        if leading != 0 { try container.encode(leading, forKey: .top) }
        if bottom != 0 { try container.encode(bottom, forKey: .top) }
        if trailing != 0 { try container.encode(trailing, forKey: .top) }
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

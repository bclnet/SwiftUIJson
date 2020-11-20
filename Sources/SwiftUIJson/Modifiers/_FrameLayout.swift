//
//  _FrameLayout.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _FrameLayout: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case width, height, alignment
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
        let height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
        let alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .center
        self = (Capsule().frame(width: width, height: height, alignment: alignment) as! ModifiedContent<Capsule, _FrameLayout>).modifier
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_FrameLayout", keys: ["width", "height", "alignment"])
        let m = Mirror.children(reflecting: self)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(m["width"]! as? CGFloat, forKey: .width)
        try container.encodeIfPresent(m["height"]! as? CGFloat, forKey: .height)
        let alignment = m["alignment"]! as! Alignment
        if alignment != .center { try container.encode(alignment, forKey: .alignment) }
    }
    //: Register
    static func register() {
        DynaType.register(_FrameLayout.self)
    }
}

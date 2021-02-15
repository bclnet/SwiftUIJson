//
//  RotatedShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension RotatedShape: IAnyShape, IAnyView, ConvertibleDynaCodable where Content : Shape, Content : DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    public init(any: Any) {
        Mirror.assert(any, name: "RotatedShape", keys: ["shape", "angle", "anchor"])
        let m = Mirror.children(reflecting: any)
        let newValue = try! PType.convert(value: m["shape"]!)
        let shape = (newValue as! IAnyShape).anyShape as! Content
        let angle = m["angle"]! as! Angle
        let anchor = m["anchor"]! as! UnitPoint
        self.init(shape: shape, angle: angle, anchor: anchor)
    }

    //: Codable
    enum CodingKeys: CodingKey {
        case shape, angle, anchor
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(angle, forKey: .angle)
        if anchor != .center { try container.encode(anchor, forKey: .anchor) }
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, ptype: ptype[0])
        let angle = try container.decode(Angle.self, forKey: .angle)
        let anchor = (try? container.decodeIfPresent(UnitPoint.self, forKey: .anchor)) ?? .center
        self.init(shape: shape, angle: angle, anchor: anchor)
    }

    //: Register
    static func register() {
        PType.register(RotatedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

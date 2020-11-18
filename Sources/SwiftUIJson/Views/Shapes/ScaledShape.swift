//
//  ScaledShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ScaledShape: IAnyShape, IAnyView, ConvertibleDynaCodable where Content : Shape, Content : DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    public init(any: Any) {
        Mirror.assert(any, name: "ScaledShape", keys: ["shape", "scale", "anchor"])
        let m = Mirror.children(reflecting: any)
        let newValue = try! DynaType.convert(value: m["shape"]!)
        let shape = (newValue as! IAnyShape).anyShape as! Content
        let scale = m["scale"]! as! CGSize
        let anchor = m["anchor"]! as! UnitPoint
        self.init(shape: shape, scale: scale, anchor: anchor)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, scale, anchor
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, dynaType: dynaType[0])
        let scale = try container.decode(CGSize.self, forKey: .scale)
        let anchor = try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center
        self.init(shape: shape, scale: scale, anchor: anchor)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(scale, forKey: .scale)
        if anchor != .center { try container.encode(anchor, forKey: .anchor) }
    }
    //: Register
    static func register() {
        DynaType.register(ScaledShape<AnyShape>.self, any: [AnyShape.self])
    }
}

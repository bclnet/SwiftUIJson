//
//  TransformedShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension TransformedShape: IAnyShape, IAnyView, ConvertibleDynaCodable where Content : Shape, Content : DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    public init(any: Any) {
        Mirror.assert(any, name: "TransformedShape", keys: ["shape", "transform"])
        let m = Mirror.children(reflecting: any)
        let newValue = try! PType.convert(value: m["shape"]!)
        let shape = (newValue as! IAnyShape).anyShape as! Content
        let transform = m["transform"]! as! CGAffineTransform
        self.init(shape: shape, transform: transform)
    }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, transform
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(transform, forKey: .transform)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, ptype: ptype[0])
        let transform = try container.decode(CGAffineTransform.self, forKey: .transform)
        self.init(shape: shape, transform: transform)
    }

    //: Register
    static func register() {
        PType.register(TransformedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

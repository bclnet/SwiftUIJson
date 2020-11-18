//
//  OffsetShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension OffsetShape: IAnyShape, IAnyView, ConvertibleDynaCodable where Content : Shape, Content : DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    public init(any: Any) {
        Mirror.assert(any, name: "OffsetShape", keys: ["shape", "offset"])
        let m = Mirror.children(reflecting: any)
        let newValue = try! DynaType.convert(value: m["shape"]!)
        let shape = (newValue as! IAnyShape).anyShape as! Content
        let offset = m["offset"]! as! CGSize
        self.init(shape: shape, offset: offset)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, offset
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, dynaType: dynaType[0])
        let offset = try container.decode(CGSize.self, forKey: .offset)
        self.init(shape: shape, offset: offset)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(offset, forKey: .offset)
    }
    //: Register
    static func register() {
        DynaType.register(OffsetShape<AnyShape>.self, any: [AnyShape.self])
    }
}

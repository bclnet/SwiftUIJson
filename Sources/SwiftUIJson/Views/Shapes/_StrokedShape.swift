//
//  _StrokedShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _StrokedShape: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, style
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(shape, forKey: .shape)
        try container.encode(style, forKey: .style)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decodeAny(IAnyShape.self, forKey: .shape, ptype: ptype[0]).anyShape as! S
        let style = try container.decode(StrokeStyle.self, forKey: .style)
        self.init(shape: shape, style: style)
    }

    //: Register
    static func register() {
        PType.register(_StrokedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

//
//  _ClipEffect.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _ClipEffect: JsonViewModifier, DynaCodable where ClipShape : DynaCodable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, style
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(ClipShape.self, forKey: .shape, dynaType: dynaType[0])
        let style = try container.decode(FillStyle.self, forKey: .style)
        self.init(shape: shape, style: style)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_ClipEffect", keys: ["shape", "style"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(style, forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(_ClipEffect<AnyShape>.self, any: [AnyShape.self])
    }
}

//
//  _OffsetEffect.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _OffsetEffect: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    //: Codable
    enum CodingKeys: CodingKey {
        case offset
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let offset = try container.decode(CGSize.self, forKey: .offset)
        self.init(offset: offset)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_OffsetEffect", keys: ["offset"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(offset, forKey: .offset)
    }
    //: Register
    static func register() {
        DynaType.register(_OffsetEffect.self)
    }
}

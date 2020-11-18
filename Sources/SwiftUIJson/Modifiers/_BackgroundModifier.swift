//
//  _BackgroundModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _BackgroundModifier: JsonViewModifier, DynaCodable where Background : DynaCodable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case background, alignment
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let background = try container.decode(Background.self, forKey: .background, dynaType: dynaType[0])
        let alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.init(background: background, alignment: alignment)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_BackgroundModifier", keys: ["background", "alignment"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(background, forKey: .background)
        try container.encode(alignment, forKey: .alignment)
    }
    //: Register
    static func register() {
        DynaType.register(_BackgroundModifier<AnyView>.self, any: [AnyView.self])
    }
}

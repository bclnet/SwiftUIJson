//
//  _OverlayModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _OverlayModifier: JsonViewModifier, DynaCodable where Overlay : DynaCodable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case overlay, alignment
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_OverlayModifier", keys: ["overlay", "alignment"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(overlay, forKey: .overlay)
        try container.encode(alignment, forKey: .alignment)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let overlay = try container.decode(Overlay.self, forKey: .overlay, ptype: ptype[0])
        let alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.init(overlay: overlay, alignment: alignment)
    }

    //: Register
    static func register() {
        PType.register(_OverlayModifier<AnyView>.self, any: [AnyView.self])
    }
}

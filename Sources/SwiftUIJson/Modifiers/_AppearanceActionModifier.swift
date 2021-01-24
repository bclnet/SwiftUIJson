//
//  _AppearanceActionModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _AppearanceActionModifier: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case appear, disappear
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeActionIfPresent(appear, forKey: .appear)
        try container.encodeActionIfPresent(disappear, forKey: .disappear)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let appear = try container.decodeActionIfPresent(forKey: .appear)
        let disappear = try container.decodeActionIfPresent(forKey: .disappear)
        self.init(appear: appear, disappear: disappear)
    }

    //: Register
    static func register() {
        PType.register(_AppearanceActionModifier.self)
    }
}

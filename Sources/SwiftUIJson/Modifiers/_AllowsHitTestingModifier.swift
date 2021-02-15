//
//  _AllowsHitTestingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _AllowsHitTestingModifier: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case allowsHitTesting
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allowsHitTesting, forKey: .allowsHitTesting)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let allowsHitTesting = try container.decode(Bool.self, forKey: .allowsHitTesting)
        self.init(allowsHitTesting: allowsHitTesting)
    }

    //: Register
    static func register() {
        PType.register(_AllowsHitTestingModifier.self)
    }
}

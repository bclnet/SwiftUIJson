//
//  _AllowsHitTestingModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _AllowsHitTestingModifier: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    //: Codable
    enum CodingKeys: CodingKey {
        case allowsHitTesting
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let allowsHitTesting = try container.decode(Bool.self, forKey: .allowsHitTesting)
        self.init(allowsHitTesting: allowsHitTesting)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allowsHitTesting, forKey: .allowsHitTesting)
    }
    //: Register
    static func register() {
        DynaType.register(_AllowsHitTestingModifier.self)
    }
}

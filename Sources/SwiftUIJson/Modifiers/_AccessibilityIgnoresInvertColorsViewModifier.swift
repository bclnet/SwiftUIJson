//
//  _AccessibilityIgnoresInvertColorsViewModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 11, tvOS 13.0, watchOS 6.0, *)
extension _AccessibilityIgnoresInvertColorsViewModifier: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case active
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(active, forKey: .active)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let active = try container.decode(Bool.self, forKey: .active)
        self.init(active: active)
    }

    //: Register
    static func register() {
        PType.register(_AccessibilityIgnoresInvertColorsViewModifier.self)
    }
}

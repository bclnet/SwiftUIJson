//
//  _PositionLayout.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _PositionLayout: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    
    //: Codable
    public func encode(to encoder: Encoder) throws { fatalError() }
    public init(from decoder: Decoder) throws { fatalError() }

    //: Register
    static func register() {
        PType.register(_PositionLayout.self)
    }
}

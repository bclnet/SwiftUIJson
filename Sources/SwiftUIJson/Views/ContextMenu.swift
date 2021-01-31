//
//  ContextMenu.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension ContextMenu: Codable where MenuItems : View {
    //: Codable
    public func encode(to encoder: Encoder) throws {}
    public init(from decoder: Decoder) throws { fatalError() }
    
    //: Register
    static func register() {
        PType.register(ContextMenu<AnyView>.self)
    }
}

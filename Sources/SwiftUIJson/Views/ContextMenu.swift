//
//  ContextMenu.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension ContextMenu: Codable where MenuItems : View {
//    public init(any: Any) {
//        Mirror.assert(any, name: "StyleContextWriter", keys: [])
//    }
    //: Codable
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
    //: Register
    static func register() {
        DynaType.register(ContextMenu<AnyView>.self)
    }
}

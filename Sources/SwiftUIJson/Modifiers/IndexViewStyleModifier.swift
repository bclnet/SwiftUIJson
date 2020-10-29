//
//  IndexViewStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct IndexViewStyleModifier<T> {
    //: Register
    static func register() {
        DynaType.register(IndexViewStyleModifier<PageIndexViewStyle>.self, any: [PageIndexViewStyle.self], namespace: "SwiftUI")
    }
}

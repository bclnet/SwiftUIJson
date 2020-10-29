//
//  ItemProviderTraitKey.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct _TraitWritingModifier<ItemProviderTraitKey> {
    //: Register
    static func register() {
        DynaType.register(ItemProviderTraitKey.self, namespace: "SwiftUI")
        DynaType.register(_TraitWritingModifier<ItemProviderTraitKey>.self, namespace: "SwiftUI")
    }
}

struct ItemProviderTraitKey {
    
}

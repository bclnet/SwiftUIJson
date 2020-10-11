//
//  LocalizedStringKey.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension LocalizedStringKey {
    var encodeValue: String {
        let mirror = Mirror.children(reflecting: self)
        return mirror["key"] as! String
    }
    public static func decodeValue(_ value: String) -> LocalizedStringKey { LocalizedStringKey(value) }
}

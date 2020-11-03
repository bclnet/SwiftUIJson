//
//  Picker.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Picker: Encodable where Label : View, SelectionValue : Hashable, Content : View {
    public func encode(to encoder: Encoder) throws {
    }
}

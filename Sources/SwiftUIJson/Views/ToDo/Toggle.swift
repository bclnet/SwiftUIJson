//
//  SwiftUI.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Toggle: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension Toggle: Encodable where Label : View {
    public func encode(to encoder: Encoder) throws {
    }
}

//
//  EmptyView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension EmptyView: IAnyView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for ptype: PType) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        PType.register(EmptyView.self)
    }
}

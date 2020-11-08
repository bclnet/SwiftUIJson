//
//  EditButton.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EditButton: JsonView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        DynaType.register(EditButton.self)
    }
}

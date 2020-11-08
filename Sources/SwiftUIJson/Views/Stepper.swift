//
//  Stepper.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Stepper: JsonView, DynaCodable where Label : View {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        DynaType.register(Stepper<AnyView>.self)
    }
}

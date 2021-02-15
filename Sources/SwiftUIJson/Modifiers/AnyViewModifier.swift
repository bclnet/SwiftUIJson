//
//  AnyViewModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol JsonViewModifier {
    func body(content: AnyView) -> AnyView
}

public struct AnyViewModifier: ViewModifier, DynaCodable {
    let modifier: Any
    public init(_ modifier: Any) {
        self.modifier = modifier
    }
    public func body(content: Content) -> some View {
        switch self.modifier {
        case let modifier as JsonViewModifier: return modifier.body(content: AnyView(content))
        case let value: fatalError("\(value)")
        }
    }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        try encoder.encodeDynaSuper(modifier)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        modifier = try decoder.dynaSuperInit(for: ptype)
    }

    //: Register
    static func register() {
        PType.register(AnyViewModifier.self)
    }
}

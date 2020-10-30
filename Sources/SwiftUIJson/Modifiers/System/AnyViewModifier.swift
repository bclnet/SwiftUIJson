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
        let modifier = self.modifier as! JsonViewModifier
        return modifier.body(content: AnyView(content))
    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        modifier = try decoder.dynaSuperInit(for: dynaType)
    }
    public func encode(to encoder: Encoder) throws {
        try encoder.encodeDynaSuper(modifier)
    }
    //: Register
    static func register() {
        DynaType.register(AnyViewModifier.self)
    }
}

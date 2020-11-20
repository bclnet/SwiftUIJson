//
//  _IdentifiedModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _IdentifiedModifier: JsonViewModifier, DynaCodable where Identifier : Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case identifier
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(Identifier.self, forKey: .identifier)
        self.init(identifier: identifier)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
    }
    //: Register
    static func register() {
        DynaType.register(_IdentifiedModifier<__DesignTimeSelectionIdentifier>.self)
    }
}

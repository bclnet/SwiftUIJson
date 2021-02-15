//
//  _SafeAreaIgnoringLayout.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _SafeAreaIgnoringLayout: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }

    //: Codable
    enum CodingKeys: CodingKey {
        case edges
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(edges, forKey: .edges)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let edges = try container.decode(Edge.Set.self, forKey: .edges)
        self.init(edges: edges)
    }

    //: Register
    static func register() {
        PType.register(_SafeAreaIgnoringLayout.self)
        if #available(OSX 11.0, *) {
            PType.register(_SafeAreaRegionsIgnoringLayout.self)
        }
    }
}

@available(OSX 11.0, *)
extension _SafeAreaRegionsIgnoringLayout: JsonViewModifier, Codable {
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case edges
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(edges, forKey: .edges)
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let edges = try container.decode(Edge.Set.self, forKey: .edges)
//        self.init(edges: edges)
        fatalError()
    }
}

//
//  _PositionLayout.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _PositionLayout: JsonViewModifier, Codable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content.modifier(self)) }
    //: Codable
    enum CodingKeys: CodingKey {
        case edges, length, insets
    }
    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let edges = (try? container.decodeIfPresent(Edge.Set.self, forKey: .edges)) ?? .all
//        let length = try? container.decodeIfPresent(CGFloat.self, forKey: .length)
//        let insets = length != nil
//            ? EdgeInsets(top: length!, leading: length!, bottom: length!, trailing: length!)
//            : try? container.decodeIfPresent(EdgeInsets.self, forKey: .insets)
//        self.init(edges: edges, insets: insets)
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if edges != .all { try container.encode(edges, forKey: .edges) }
//        guard let insets = insets else { return }
//        if insets.isEqual {
//            if insets.top != 0 { try container.encode(insets.top, forKey: .length) }
//            return
//        }
//        try container.encode(insets, forKey: .insets)
    }
    //: Register
    static func register() {
        DynaType.register(_PositionLayout.self)
    }
}

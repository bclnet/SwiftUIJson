//
//  _PaddingLayout.swift (Incomplete, view test fail)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _PaddingLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case edges, insets
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let edges = try container.decode(Edge.Set.self, forKey: .edges)
        let insets = try container.decodeIfPresent(EdgeInsets.self, forKey: .insets)
        self.init(edges: edges, insets: insets)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(edges, forKey: .edges)
        try container.encodeIfPresent(insets, forKey: .insets)
    }
}

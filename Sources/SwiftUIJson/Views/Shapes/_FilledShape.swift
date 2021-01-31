//
//  _FilledShape.swift (check name)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _FilledShape: DynaCodable where S : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, style
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_FilledShape: ", keys: ["shape", "style"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(style, forKey: .style)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(S.self, forKey: .shape, ptype: ptype[0])
        let size = try container.decode(FillStyle.self, forKey: .style)
        self.init(shape: shape, style: style)
    }

    //: Register
    static func register() {
        PType.register(_FilledShape<AnyShape>.self, any: [AnyShape.self])
    }
}

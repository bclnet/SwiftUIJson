//
//  _TrimmedShape.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _TrimmedShape: IAnyView, DynaCodable where S : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, startFraction, endFraction
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(S.self, forKey: .shape, ptype: ptype[0])
        let startFraction = try container.decode(CGFloat.self, forKey: .startFraction)
        let endFraction = try container.decode(CGFloat.self, forKey: .endFraction)
        self.init(shape: shape, startFraction: startFraction, endFraction: endFraction)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_TrimmedShape", keys: ["shape", "startFraction", "endFraction"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(startFraction, forKey: .startFraction)
        try container.encode(endFraction, forKey: .endFraction)
    }
    //: Register
    static func register() {
        PType.register(_TrimmedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

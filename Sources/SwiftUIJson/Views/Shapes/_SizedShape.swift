//
//  _SizedShape.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _SizedShape: DynaCodable where S : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, size
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(S.self, forKey: .shape, dynaType: dynaType[0])
        let size = try container.decode(CGSize.self, forKey: .size)
        self.init(shape: shape, size: size)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_SizedShape", keys: ["shape", "size"])
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(size, forKey: .size)
    }
    //: Register
    static func register() {
        DynaType.register(_SizedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

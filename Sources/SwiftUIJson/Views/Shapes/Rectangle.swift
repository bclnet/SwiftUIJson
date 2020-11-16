//
//  Rectangle.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Rectangle: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        DynaType.register(Rectangle.self)
        DynaType.register(Rectangle._Inset.self)
    }
    
    struct _Inset: IAnyView, ConvertibleDynaCodable {
        public var anyView: AnyView { AnyView(Rectangle().inset(by: self.amount)) }
        let amount: CGFloat
        public init(any: Any) {
            Mirror.assert(any, name: "_Inset", keys: ["amount"])
            amount = Mirror(reflecting: any).descendant("amount") as! CGFloat
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case amount
        }
        public init(from decoder: Decoder, for dynaType: DynaType) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            amount = try container.decode(CGFloat.self, forKey: .amount)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(amount, forKey: .amount)
        }
    }
}

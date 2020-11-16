//
//  OffsetShape.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension OffsetShape: IAnyShape, DynaCodable where Content : Shape, Content : DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, offset
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, dynaType: dynaType[0])
        let offset = try container.decode(CGSize.self, forKey: .offset)
        self.init(shape: shape, offset: offset)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(offset, forKey: .offset)
    }
    //: Register
    static func register() {
        DynaType.register(OffsetShape<AnyShape>.self)
        DynaType.register(OffsetShape._Inset<AnyShape>.self)
    }
    
    struct _Inset<Content>: IAnyView, ConvertibleDynaCodable where Content : Shape {
        public var anyView: AnyView {
            fatalError()
//            AnyView(OffsetShape().inset(by: self.amount))
        }
        let amount: CGFloat
        public init(any: Any) {
//            Mirror.assert(any, name: "_Inset", keys: ["amount"])
//            amount = Mirror(reflecting: any).descendant("amount") as! CGFloat
//            let m = Mirror.children(reflecting: any)
            fatalError()
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

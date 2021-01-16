//
//  ContainerRelativeShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContainerRelativeShape: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    public init(from decoder: Decoder, for ptype: PType) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
    //: Register
    static func register() {
        PType.register(ContainerRelativeShape.self)
        PType.register(ContainerRelativeShape._Inset.self)
    }
    
    struct _Inset: IAnyShape, IAnyView, ConvertibleDynaCodable {
        public var anyShape: AnyShape { AnyShape(ContainerRelativeShape().inset(by: self.amount)) }
        public var anyView: AnyView { AnyView(ContainerRelativeShape().inset(by: self.amount)) }
        let amount: CGFloat
        public init(any: Any) {
            Mirror.assert(any, name: "_Inset", keys: ["amount"])
            amount = Mirror(reflecting: any).descendant("amount") as! CGFloat
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case amount
        }
        public init(from decoder: Decoder, for ptype: PType) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            amount = try container.decode(CGFloat.self, forKey: .amount)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(amount, forKey: .amount)
        }
    }
}

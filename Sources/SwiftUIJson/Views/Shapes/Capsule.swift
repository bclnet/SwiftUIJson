//
//  Capsule.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Capsule: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }

    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if style != .circular { try container.encode(style, forKey: .style) }
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let style = (try? container.decodeIfPresent(RoundedCornerStyle.self, forKey: .style)) ?? .circular
        self.init(style: style)
    }

    //: Register
    static func register() {
        PType.register(Capsule.self)
        PType.register(Capsule._Inset.self)
    }
    
    struct _Inset: IAnyShape, IAnyView, ConvertibleDynaCodable {
        public var anyShape: AnyShape { AnyShape(Capsule().inset(by: self.amount)) }
        public var anyView: AnyView { AnyView(Capsule().inset(by: self.amount)) }
        let amount: CGFloat
        public init(any: Any) {
            Mirror.assert(any, name: "_Inset", keys: ["amount"])
            amount = Mirror(reflecting: any).descendant("amount") as! CGFloat
        }
        
        //: Codable
        enum CodingKeys: CodingKey {
            case amount
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(amount, forKey: .amount)
        }
        public init(from decoder: Decoder, for ptype: PType) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            amount = try container.decode(CGFloat.self, forKey: .amount)
        }
    }
}

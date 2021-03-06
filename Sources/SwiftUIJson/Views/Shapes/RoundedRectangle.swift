//
//  RoundedRectangle.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension RoundedRectangle: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }

    //: Codable
    enum CodingKeys: CodingKey {
        case cornerSize, cornerRadius, style
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if cornerSize.width != cornerSize.height { try container.encode(cornerSize, forKey: .cornerSize) }
        else { try container.encode(cornerSize.width, forKey: .cornerRadius) }
        if style != .circular { try container.encode(style, forKey: .style) }
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cornerSize = try? container.decodeIfPresent(CGSize.self, forKey: .cornerSize)
        let cornerRadius = try? container.decodeIfPresent(CGFloat.self, forKey: .cornerRadius)
        let style = (try? container.decodeIfPresent(RoundedCornerStyle.self, forKey: .style)) ?? .circular
        if cornerSize != nil { self.init(cornerSize: cornerSize!, style: style) }
        else { self.init(cornerRadius: cornerRadius!, style: style) }
    }

    //: Register
    static func register() {
        PType.register(RoundedRectangle.self)
        PType.register(RoundedRectangle._Inset.self)
    }
    
    struct _Inset: IAnyShape, IAnyView, ConvertibleDynaCodable {
        public var anyShape: AnyShape { AnyShape(Rectangle().inset(by: self.amount)) }
        public var anyView: AnyView { AnyView(base.inset(by: self.amount)) }
        let base: RoundedRectangle
        let amount: CGFloat
        public init(any: Any) {
            Mirror.assert(any, name: "_Inset", keys: ["base", "amount"])
            let m = Mirror.children(reflecting: any)
            base = m["base"]! as! RoundedRectangle
            amount = m["amount"]! as! CGFloat
        }

        //: Codable
        enum CodingKeys: CodingKey {
            case base, amount
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            try container.encode(amount, forKey: .amount)
        }
        public init(from decoder: Decoder, for ptype: PType) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(RoundedRectangle.self, forKey: .base, ptype: ptype[0])
            amount = try container.decode(CGFloat.self, forKey: .amount)
        }
    }
}

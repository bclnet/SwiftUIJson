//
//  _ShapeView.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

//extension _ShapeView: IAnyShape, DynaCodable { //where Content : DynaCodable {
//    public var anyShape: AnyShape { AnyShape(self) }
//    public var anyView: AnyView { AnyView(self) }
//    //: Codable
//    enum CodingKeys: CodingKey {
//        case style
//    }
//    public init(from decoder: Decoder, for dynaType: DynaType) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        let style = try container.decodeIfPresent(RoundedCornerStyle.self, forKey: .style) ?? .circular
////        self.init(style: style)
//        fatalError()
//    }
//    public func encode(to encoder: Encoder) throws {
////        var container = encoder.container(keyedBy: CodingKeys.self)
////        if style != .circular { try container.encode(style, forKey: .style) }
//        let m = Mirror.children(reflecting: self)
//    }
//    //: Register
//    static func register() {
//        DynaType.register(_ShapeView<AnyShape>.self, any: [AnyShape.self])
//    }
//}

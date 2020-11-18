//
//  _ShapeView.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _ShapeView: IAnyView, DynaCodable where Content : DynaCodable, Style : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, style, fillStyle
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decode(Content.self, forKey: .shape, dynaType: dynaType[0])
        let style = try container.decode(Style.self, forKey: .style, dynaType: dynaType[1])
        let fillStyle = try container.decode(FillStyle.self, forKey: .fillStyle)
        self.init(shape: shape, style: style, fillStyle: fillStyle)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shape, forKey: .shape)
        try container.encode(style, forKey: .style)
        try container.encode(fillStyle, forKey: .fillStyle)
    }
    //: Register
    static func register() {
//        DynaType.register(_ShapeView<AnyShape, AngularGradient>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, BackgroundStyle>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, Color>.self, any: [AnyShape.self])
        DynaType.register(_ShapeView<AnyShape, ForegroundStyle>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, ImagePaint>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, LinearGradient>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, RadialGradient>.self, any: [AnyShape.self])
//        #if !os(iOS)
//        DynaType.register(_ShapeView<AnyShape, SelectionShapeStyle>.self, any: [AnyShape.self])
//        DynaType.register(_ShapeView<AnyShape, SeparatorShapeStyle>.self, any: [AnyShape.self])
//        #endif
    }
}

extension FillStyle: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case eoFill, antialiased
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eoFill = try container.decodeIfPresent(Bool.self, forKey: .eoFill) ?? true
        let antialiased = try container.decodeIfPresent(Bool.self, forKey: .antialiased) ?? true
        self.init(eoFill: eoFill, antialiased: antialiased)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if isEOFilled { try container.encode(isEOFilled, forKey: .eoFill) }
        if isAntialiased { try container.encode(isAntialiased, forKey: .antialiased) }
    }
}

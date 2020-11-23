//
//  _StrokedShape.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _StrokedShape: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case shape, style
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let shape = try container.decodeAny(IAnyShape.self, forKey: .shape, dynaType: dynaType[0]).anyShape as! S
        let style = try container.decode(StrokeStyle.self, forKey: .style)
        self.init(shape: shape, style: style)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(shape, forKey: .shape)
        try container.encode(style, forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(_StrokedShape<AnyShape>.self, any: [AnyShape.self])
    }
}

extension StrokeStyle: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case lineWidth, lineCap, lineJoin, miterLimit, dash, dashPhase
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lineWidth = (try? container.decodeIfPresent(CGFloat.self, forKey: .lineWidth)) ?? 1
        let lineCap = (try? container.decodeIfPresent(CGLineCap.self, forKey: .lineCap)) ?? .butt
        let lineJoin = (try? container.decodeIfPresent(CGLineJoin.self, forKey: .lineJoin)) ?? .miter
        let miterLimit = (try? container.decodeIfPresent(CGFloat.self, forKey: .miterLimit)) ?? 10
        let dash = (try? container.decodeIfPresent([CGFloat].self, forKey: .dash)) ?? [CGFloat]()
        let dashPhase = (try? container.decodeIfPresent(CGFloat.self, forKey: .dashPhase)) ?? 0
        self.init(lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, miterLimit: miterLimit, dash: dash, dashPhase: dashPhase)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if lineWidth != 1 { try container.encode(lineWidth, forKey: .lineWidth) }
        if lineCap != .butt { try container.encode(lineCap, forKey: .lineCap) }
        if lineJoin != .miter { try container.encode(lineJoin, forKey: .lineJoin) }
        if miterLimit != 10 { try container.encode(miterLimit, forKey: .miterLimit) }
        if dash.count != 0 { try container.encode(dash, forKey: .dash) }
        if dashPhase != 0 { try container.encode(dashPhase, forKey: .dashPhase) }
    }
}

extension CGLineCap: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "butt": self = .butt
        case "round": self = .round
        case "square": self = .square
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .butt: try container.encode("butt")
        case .round: try container.encode("round")
        case .square: try container.encode("square")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

extension CGLineJoin: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "miter": self = .miter
        case "round": self = .round
        case "bevel": self = .bevel
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .miter: try container.encode("miter")
        case .round: try container.encode("round")
        case .bevel: try container.encode("bevel")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

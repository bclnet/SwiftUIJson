//
//  Path.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension CGLineCap: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .butt: try container.encode("butt")
        case .round: try container.encode("round")
        case .square: try container.encode("square")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "butt": self = .butt
        case "round": self = .round
        case "square": self = .square
        case let value: fatalError(value)
        }
    }
}

extension CGLineJoin: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .miter: try container.encode("miter")
        case .round: try container.encode("round")
        case .bevel: try container.encode("bevel")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "miter": self = .miter
        case "round": self = .round
        case "bevel": self = .bevel
        case let value: fatalError(value)
        }
    }
}

extension FillStyle: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case eoFill, antialiased
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !isEOFilled { try container.encode(isEOFilled, forKey: .eoFill) }
        if !isAntialiased { try container.encode(isAntialiased, forKey: .antialiased) }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eoFill = (try? container.decodeIfPresent(Bool.self, forKey: .eoFill)) ?? false
        let antialiased = (try? container.decodeIfPresent(Bool.self, forKey: .antialiased)) ?? false
        self.init(eoFill: eoFill, antialiased: antialiased)
    }
}


struct FixedRoundedRect: Codable {
    let rect: CGRect
    let cornerSize: CGSize
    let style: RoundedCornerStyle
    init(any: Any) {
        Mirror.assert(any, name: "FixedRoundedRect", keys: ["rect", "cornerSize", "style"])
        let m = Mirror.children(reflecting: any)
        rect = m["rect"]! as! CGRect
        cornerSize = m["cornerSize"]! as! CGSize
        style = m["style"]! as! RoundedCornerStyle
    }
}

extension RoundedCornerStyle: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .circular: try container.encode("circular")
        case .continuous: try container.encode("continuous")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "circular": self = .circular
        case "continuous": self = .continuous
        case let value: fatalError(value)
        }
    }
}

extension StrokeStyle: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case lineWidth, lineCap, lineJoin, miterLimit, dash, dashPhase
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
}
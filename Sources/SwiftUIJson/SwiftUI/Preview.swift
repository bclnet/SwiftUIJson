//
//  PreviewLayout.swift
//  review
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension PreviewLayout: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "device": self = .device
        case "sizeThatFits": self = .sizeThatFits
        case let value: fatalError(value)
//        case let value:
//            let f = NumberFormatter()
//            let str = value.components(separatedBy: "x")
//            guard let x = f.number(from: str[0]) else { fatalError() }
//            guard let y = f.number(from: str[1]) else { fatalError() }
//            self = .fixed(width: CGFloat(truncating: x), height: CGFloat(truncating: y))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .device: try container.encode("device")
        case .sizeThatFits: try container.encode("sizeThatFits")
        case .fixed(let width, let height): try container.encode("fixed:\(width)x\(height)")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

extension PreviewPlatform: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "iOS": self = .iOS
        case "macOS": self = .macOS
        case "tvOS": self = .tvOS
        case "watchOS": self = .watchOS
        case let value: fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .iOS: try container.encode("iOS")
        case .macOS: try container.encode("macOS")
        case .tvOS: try container.encode("tvOS")
        case .watchOS: try container.encode("watchOS")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

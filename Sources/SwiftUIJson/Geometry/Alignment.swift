//
//  Alignment.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Alignment: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .center: try container.encode("center")
        case .leading: try container.encode("leading")
        case .trailing: try container.encode("trailing")
        case .top: try container.encode("top")
        case .bottom: try container.encode("bottom")
        case .topLeading: try container.encode("topLeading")
        case .topTrailing: try container.encode("topTrailing")
        case .bottomLeading: try container.encode("bottomLeading")
        case .bottomTrailing: try container.encode("bottomTrailing")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        case let value: fatalError(value)
        }
    }
}

extension HorizontalAlignment: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .leading: try container.encode("leading")
        case .center: try container.encode("center")
        case .trailing: try container.encode("trailing")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "leading": self = .leading
        case "center": self = .center
        case "trailing": self = .trailing
        case let value: fatalError(value)
        }
    }
}

extension VerticalAlignment: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .top: try container.encode("top")
        case .center: try container.encode("center")
        case .bottom: try container.encode("bottom")
        case .firstTextBaseline: try container.encode("firstTextBaseline")
        case .lastTextBaseline: try container.encode("lastTextBaseline")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "top": self = .top
        case "center": self = .center
        case "bottom": self = .bottom
        case "firstTextBaseline": self = .firstTextBaseline
        case "lastTextBaseline": self = .lastTextBaseline
        case let value: fatalError(value)
        }
    }
}
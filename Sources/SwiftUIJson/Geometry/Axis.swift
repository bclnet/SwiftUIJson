//
//  Axis.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Axis: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Axis")
        var container = encoder.singleValueContainer()
        switch self {
        case .horizontal: try container.encode("horizontal")
        case .vertical: try container.encode("vertical")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "horizontal": self = .horizontal
        case "vertical": self = .vertical
        case let value: fatalError(value)
        }
    }
}

extension Axis.Set: CaseIterable, Codable {
    public static let allCases: [Self] = [.horizontal, .vertical]
    
    //: Codable
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Set")
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .horizontal: try container.encode("horizontal")
                case .vertical: try container.encode("vertical")
                case let value: fatalError("\(value)")
//                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "horizontal": elements.insert(.horizontal)
            case "vertical": elements.insert(.vertical)
            case let value: self.init(rawValue: RawValue(value)!); return
            }
        }
        self = elements
    }
}

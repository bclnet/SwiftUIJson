//
//  UnitPoint.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension UnitPoint: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "zero": self = .zero
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        case "": self.init()
        case let x_y:
            let f = NumberFormatter()
            let str = x_y.components(separatedBy: "x")
            guard let x = f.number(from: str[0]) else { fatalError() }
            guard let y = f.number(from: str[1]) else { fatalError() }
            self.init(x: CGFloat(truncating: x), y: CGFloat(truncating: y))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .zero: try container.encode("zero")
        case .center: try container.encode("center")
        case .leading: try container.encode("leading")
        case .trailing: try container.encode("trailing")
        case .top: try container.encode("top")
        case .bottom: try container.encode("bottom")
        case .topLeading: try container.encode("topLeading")
        case .topTrailing: try container.encode("topTrailing")
        case .bottomLeading: try container.encode("bottomLeading")
        case .bottomTrailing: try container.encode("bottomTrailing")
        default:
            if x == 0 && y == 0 { try container.encode("") }
            else { try container.encode("\(x)x\(y)") }
        }
    }
}

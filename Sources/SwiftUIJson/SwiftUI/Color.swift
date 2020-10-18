//
//  Color.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case colorSpace, cgColor
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "clear": self = .clear
        case "black": self = .black
        case "white": self = .white
        case "gray": self = .gray
        case "red": self = .red
        case "green": self = .green
        case "blue": self = .blue
        case "orange": self = .orange
        case "yellow": self = .yellow
        case "pink": self = .pink
        case "purple": self = .purple
        case "primary": self = .primary
        case "secondary": self = .secondary
        default: //TODO: Here
            //        if value.starts(with: "~") {
            //            let colorSpace = try container.decode(String.self, forKey: .colorSpace) as CFString
            //            let components = try container.decode([CGFloat].self, forKey: .cgColor)
            //            self.init(CGColor(colorSpace: CGColorSpace(name: colorSpace)!, components: components)!)
            //            return
            //        }
            fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .clear: try container.encode("clear")
        case .black: try container.encode("black")
        case .white: try container.encode("white")
        case .gray: try container.encode("gray")
        case .red: try container.encode("red")
        case .green: try container.encode("green")
        case .blue: try container.encode("blue")
        case .orange: try container.encode("orange")
        case .yellow: try container.encode("yellow")
        case .pink: try container.encode("pink")
        case .purple: try container.encode("purple")
        case .primary: try container.encode("primary")
        case .secondary: try container.encode("secondary")
        default: //TODO: Here
            //        if self.cgColor == nil {
            //            try container.encode(self.cgColor!.colorSpace?.name.debugDescription, forKey: .colorSpace)
            //            try container.encode(self.cgColor!.components, forKey: .cgColor)
            //            return
            //        }
            fatalError()
        }
    }
}

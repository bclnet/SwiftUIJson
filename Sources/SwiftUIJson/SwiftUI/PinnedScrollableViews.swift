//
//  PinnedScrollableViews.swift (Incomplete)
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension PinnedScrollableViews: CaseIterable, Codable {
    public static let allCases: [Self] = [.sectionHeaders, .sectionFooters]
    
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .sectionHeaders: try container.encode("sectionHeaders")
                case .sectionFooters: try container.encode("sectionFooters")
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
            case "sectionHeaders": elements.insert(.sectionHeaders)
            case "sectionFooters": elements.insert(.sectionFooters)
            case let value: self.init(rawValue: RawValue(value)!); return
            }
        }
        self = elements
    }
}

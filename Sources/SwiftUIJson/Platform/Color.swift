//
//  Color.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

#if os(macOS)
public typealias UXColor = NSColor
#else
public typealias UXColor = UIColor
#endif

extension CGColor {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        #if os(macOS)
        let color = UXColor(cgColor: self)!
        #else
        let color = UXColor(cgColor: self)
        #endif
        try color.encode(to: encoder)
    }
    public static func decode(from decoder: Decoder) throws -> CGColor {
        try UXColor.decode(from: decoder).cgColor
    }
}

extension UXColor {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        let coder = NSKeyedArchiver(requiringSecureCoding: false)
        self.encode(with: coder)
        var container = encoder.singleValueContainer()
        try container.encode(coder.encodedData)
    }
    public static func decode(from decoder: Decoder) throws -> UXColor {
        let container = try decoder.singleValueContainer()
        let decodedData = try container.decode(Data.self)
        let coder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        guard let color = UXColor(coder: coder) else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "") }
        return color
    }
}

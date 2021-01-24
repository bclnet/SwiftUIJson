//
//  CodableWrap.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol WrapableCodable {
    associatedtype Value
    var wrapValue: Value { get }

    //: Codable
    func encode(to encoder: Encoder) throws
    static func decode(from decoder: Decoder) throws -> Self
}

public struct CodableWrap<Wrap>: Codable where Wrap : WrapableCodable {
    public let wrap: Wrap
    public var wrapValue: Wrap.Value { wrap.wrapValue }
    public init(_ wrap: Wrap) {
        self.wrap = wrap
    }
    public init?(_ wrap: Wrap?) {
        guard let wrap = wrap else { return nil }
        self.wrap = wrap
    }

    //: Codable
    public func encode(to encoder: Encoder) throws {
        try wrap.encode(to: encoder)
    }
    public init(from decoder: Decoder) throws {
        wrap = try Wrap.decode(from: decoder)
    }
    
}

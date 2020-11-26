//
//  CodableWrap.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol WrapableCodeable {
    associatedtype Value
    var wrapValue: Value { get }
    static func decode(from decoder: Decoder) throws -> Self
    func encode(to encoder: Encoder) throws
}

public struct CodableWrap<Wrap>: Codable where Wrap : WrapableCodeable {
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
    public init(from decoder: Decoder) throws {
        wrap = try Wrap.decode(from: decoder)
    }
    public func encode(to encoder: Encoder) throws {
        try wrap.encode(to: encoder)
    }
}

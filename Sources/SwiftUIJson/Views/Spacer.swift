//
//  Spacer.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Spacer: IAnyView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case minLength
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let minLength = try container.decodeIfPresent(CGFloat.self, forKey: .minLength)
        self.init(minLength: minLength)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let minLength = Mirror(reflecting: self).descendant("minLength") as? CGFloat
        try container.encodeIfPresent(minLength, forKey: .minLength)
    }
    //: Register
    static func register() {
        DynaType.register(Spacer.self)
    }
}

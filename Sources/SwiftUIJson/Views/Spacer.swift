//
//  Spacer.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Spacer: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension Spacer: DynaCodable {
    // MARK - Codable
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
}
  
extension _HSpacer: Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}
  
extension _VSpacer : Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}

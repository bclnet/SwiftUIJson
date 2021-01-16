//
//  GeometryReader.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension GeometryReader: IAnyView, DynaCodable where Content : View {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decodeFunc(GeometryProxy.self, Content.self, forKey: .content)
        self.init(content: content)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeFunc(content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(GeometryReader<AnyView>.self)
    }
}

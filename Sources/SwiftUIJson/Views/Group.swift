//
//  Group.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Group: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
        self.init(content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Group", keys: ["content"])
        let content = Mirror(reflecting: self).descendant("content")! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(Group<AnyView>.self)
    }
}

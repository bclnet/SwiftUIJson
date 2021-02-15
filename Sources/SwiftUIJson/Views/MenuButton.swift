//
//  MenuButton.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension MenuButton: IAnyView, DynaCodable where Label : View, Label : DynaCodable, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case label, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(Label.self, forKey: .label, ptype: ptype[0])
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[1])
        self.init(label: label, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "MenuButton", keys: ["label", "content"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(MenuButton<AnyView, AnyView>.self)
    }
}

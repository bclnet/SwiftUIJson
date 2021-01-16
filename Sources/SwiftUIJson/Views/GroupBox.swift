//
//  GroupBox.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension GroupBox: IAnyView, DynaCodable where Label : View, Label : DynaCodable, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case label, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = (try container.decodeIfPresent(Label.self, forKey: .label, ptype: ptype[0])) ?? (AnyView(EmptyView()) as! Label)
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[1])
        self.init(label: label, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "GroupBox", keys: ["_namespace", "label", "content"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as? Label
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(GroupBox<AnyView, AnyView>.self)
    }
}

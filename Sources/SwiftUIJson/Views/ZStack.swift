//
//  ZStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ZStack: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }

    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "ZStack", keys: ["_tree"])
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_ZStackLayout, Content>
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center {
            try container.encode(root, forKey: .root)
        }
        try container.encode(tree.content, forKey: .content)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(_ZStackLayout.self, forKey: .root)) ?? _ZStackLayout()
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        self.init(alignment: root.alignment, content: { content })
    }

    //: Register
    static func register() {
        PType.register(ZStack<AnyView>.self)
    }
}

extension _ZStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case alignment
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.alignment, forKey: .alignment)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.init(alignment: alignment)
    }
}

//
//  VStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension VStack: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(_VStackLayout.self, forKey: .root)) ?? _VStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        self.init(alignment: root.alignment, spacing: root.spacing, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "VStack", keys: ["_tree"])
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_VStackLayout, Content>
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(VStack<AnyView>.self)
    }
}

extension _VStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case alignment, spacing
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alignment = try container.decode(HorizontalAlignment.self, forKey: .alignment)
        let spacing = try? container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        self.init(alignment: alignment, spacing: spacing)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alignment, forKey: .alignment)
        try container.encodeIfPresent(spacing, forKey: .spacing)
    }
}

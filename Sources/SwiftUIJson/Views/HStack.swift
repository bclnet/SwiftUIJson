//
//  HStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension HStack: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "HStack", keys: ["_tree"])
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_HStackLayout, Content>
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(_HStackLayout.self, forKey: .root)) ?? _HStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }

    //: Register
    static func register() {
        PType.register(HStack<AnyView>.self)
    }
}

extension _HStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case spacing, alignment
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spacing = try? container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(VerticalAlignment.self, forKey: .alignment)
        self.init(alignment: alignment, spacing: spacing)
    }
}

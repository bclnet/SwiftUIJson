//
//  LazyVStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LazyVStack: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(LazyVStackLayout.self, forKey: .root)) ?? LazyVStackLayout(alignment: .center, spacing: nil, pinnedViews: .init())
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        self.init(alignment: root.alignment, spacing: root.spacing, pinnedViews: root.pinnedViews, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "LazyVStack", keys: ["tree"])
        let tree = Tree<LazyVStackLayout, Content>(any: Mirror(reflecting: self).descendant("tree")!)
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil || root.pinnedViews.rawValue != 0 { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(LazyVStack<AnyView>.self)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct LazyVStackLayout: _Tree_ViewRoot {
    let base: _VStackLayout
    var alignment: HorizontalAlignment { base.alignment }
    var spacing: CGFloat? { base.spacing }
    let pinnedViews: PinnedScrollableViews
    init(alignment: HorizontalAlignment, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews) {
        base = _VStackLayout(alignment: alignment, spacing: spacing)
        self.pinnedViews = pinnedViews
    }
    init(any: Any) {
        Mirror.assert(any, name: "LazyVStackLayout", keys: ["base", "pinnedViews"])
        let m = Mirror.children(reflecting: any)
        base = m["base"]! as! _VStackLayout
        pinnedViews = m["pinnedViews"]! as! PinnedScrollableViews
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LazyVStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case spacing, alignment, pinnedViews
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spacing = try? container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(HorizontalAlignment.self, forKey: .alignment)
        let pinnedViews = try container.decode(PinnedScrollableViews.self, forKey: .pinnedViews)
        self.init(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
        try container.encode(self.pinnedViews, forKey: .pinnedViews)
    }
}

//
//  LazyVStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension LazyVStack: JsonView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeIfPresent(LazyVStackLayout.self, forKey: .root) ?? LazyVStackLayout(alignment: .center, spacing: nil, pinnedViews: .init())
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType, depth: depth + 1)
        self.init(alignment: root.alignment, spacing: root.spacing, pinnedViews: root.pinnedViews) { content }
    }
    public func encode(to encoder: Encoder) throws {
        let tree = Tree<LazyVStackLayout, Content>(any: Mirror(reflecting: self).descendant("tree")!), root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil || root.pinnedViews.rawValue != 0 { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal struct LazyVStackLayout: _Tree_ViewRoot {
    private let base: _VStackLayout
    var alignment: HorizontalAlignment { base.alignment }
    var spacing: CGFloat? { base.spacing }
    let pinnedViews: PinnedScrollableViews
    init(any s: Any) {
        let base = Mirror.children(reflecting: s)
        self.base = base["base"] as! _VStackLayout
        self.pinnedViews = base["pinnedViews"] as! PinnedScrollableViews
    }
    init(alignment: HorizontalAlignment, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews) {
        self.base = _VStackLayout(alignment: alignment, spacing: spacing)
        self.pinnedViews = pinnedViews
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
        let spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(HorizontalAlignment.self, forKey: .alignment)
        let pinnedViews = PinnedScrollableViews(rawValue: try container.decode(UInt32.self, forKey: .pinnedViews))
        self.init(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
        try container.encode(self.pinnedViews.rawValue, forKey: .pinnedViews)
    }
}

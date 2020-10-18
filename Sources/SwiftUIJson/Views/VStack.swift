//
//  VStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension VStack: JsonView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeIfPresent(_VStackLayout.self, forKey: .root) ?? _VStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType, depth: depth + 1)
        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }
    public func encode(to encoder: Encoder) throws {
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_VStackLayout, Content>, root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension HorizontalAlignment: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "leading": self = .leading
        case "center": self = .center
        case "trailing": self = .trailing
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid"))
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .leading: try container.encode("leading")
        case .center: try container.encode("center")
        case .trailing: try container.encode("trailing")
        default: fatalError()
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension _VStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case spacing, alignment
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(HorizontalAlignment.self, forKey: .alignment)
        self.init(alignment: alignment, spacing: spacing)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
    }
}

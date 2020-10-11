//
//  VStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension VStack: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension VStack: DynaCodable where Content : View, Content : DynaCodable {
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeIfPresent(_VStackLayout.self, forKey: .root) ?? _VStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType)
        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }
    public func encode(to encoder: Encoder) throws {
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_VStackLayout, Content>
        var container = encoder.container(keyedBy: CodingKeys.self)
        if tree.root.alignment != .center || tree.root.spacing != nil { try container.encode(tree.root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
}

extension HorizontalAlignment: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "leading": self = .leading
        case "center": self = .center
        case "trailing": self = .trailing
        default:
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid")
            throw DecodingError.dataCorrupted(context)
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

extension _VStackLayout: Codable {
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

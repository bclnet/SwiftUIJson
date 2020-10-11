//
//  HStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension HStack: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension HStack: DynaCodable where Content : View, Content : DynaCodable {
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeIfPresent(_HStackLayout.self, forKey: .root) ?? _HStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType)
        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }
    public func encode(to encoder: Encoder) throws {
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_HStackLayout, Content>
        var container = encoder.container(keyedBy: CodingKeys.self)
        if tree.root.alignment != .center || tree.root.spacing != nil { try container.encode(tree.root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
}

extension VerticalAlignment: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "top": self = .top
        case "center": self = .center
        case "bottom": self = .bottom
        case "firstTextBaseline": self = .firstTextBaseline
        case "lastTextBaseline": self = .lastTextBaseline
        default:
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid")
            throw DecodingError.dataCorrupted(context)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .top: try container.encode("top")
        case .center: try container.encode("center")
        case .bottom: try container.encode("bottom")
        case .firstTextBaseline: try container.encode("firstTextBaseline")
        case .lastTextBaseline: try container.encode("lastTextBaseline")
        default: fatalError()
        }
    }
}

extension _HStackLayout: Codable {
    enum CodingKeys: CodingKey {
        case spacing, alignment
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(VerticalAlignment.self, forKey: .alignment)
        self.init(alignment: alignment, spacing: spacing)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
    }
}

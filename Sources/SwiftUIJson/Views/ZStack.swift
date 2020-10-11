//
//  ZStack.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ZStack: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension ZStack: DynaCodable where Content : View, Content : DynaCodable {
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeIfPresent(_ZStackLayout.self, forKey: .root) ?? _ZStackLayout(alignment: .center)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType)
        self.init(alignment: root.alignment) { content }
    }
    public func encode(to encoder: Encoder) throws {
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_ZStackLayout, Content>
        var container = encoder.container(keyedBy: CodingKeys.self)
        if tree.root.alignment != .center { try container.encode(tree.root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
}

extension Alignment: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        default:
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid")
            throw DecodingError.dataCorrupted(context)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .center: try container.encode("center")
        case .leading: try container.encode("leading")
        case .trailing: try container.encode("trailing")
        case .top: try container.encode("top")
        case .bottom: try container.encode("bottom")
        case .topLeading: try container.encode("topLeading")
        case .topTrailing: try container.encode("topTrailing")
        case .bottomLeading: try container.encode("bottomLeading")
        case .bottomTrailing: try container.encode("bottomTrailing")
        default: fatalError()
        }
    }
}

extension _ZStackLayout: Codable {
    enum CodingKeys: CodingKey {
        case spacing, alignment
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.init(alignment: alignment)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.alignment, forKey: .alignment)
    }
}

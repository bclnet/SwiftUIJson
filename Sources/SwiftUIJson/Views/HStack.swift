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
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(_HStackLayout.self, forKey: .root)) ?? _HStackLayout(alignment: .center, spacing: nil)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "HStack", keys: ["_tree"])
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_HStackLayout, Content>
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center || root.spacing != nil { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(HStack<AnyView>.self)
    }
}

extension VerticalAlignment: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "top": self = .top
        case "center": self = .center
        case "bottom": self = .bottom
        case "firstTextBaseline": self = .firstTextBaseline
        case "lastTextBaseline": self = .lastTextBaseline
        case let unrecognized: fatalError(unrecognized)
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
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

extension _HStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case spacing, alignment
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spacing = try? container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        let alignment = try container.decode(VerticalAlignment.self, forKey: .alignment)
        self.init(alignment: alignment, spacing: spacing)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spacing, forKey: .spacing)
        try container.encode(self.alignment, forKey: .alignment)
    }
}

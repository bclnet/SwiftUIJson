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
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = (try? container.decodeIfPresent(_ZStackLayout.self, forKey: .root)) ?? _ZStackLayout(alignment: .center)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
        self.init(alignment: root.alignment, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "ZStack", keys: ["_tree"])
        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_ZStackLayout, Content>
        let root = tree.root
        var container = encoder.container(keyedBy: CodingKeys.self)
        if root.alignment != .center { try container.encode(root, forKey: .root) }
        try container.encode(tree.content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(ZStack<AnyView>.self)
    }
}

extension Alignment: Codable {
    //: Codable
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
        case let unrecognized: fatalError(unrecognized)
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
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

extension _ZStackLayout: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case alignment
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

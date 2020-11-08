//
//  _VariadicView.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _VariadicView {
    //: Register
    static func register() {
        DynaType.register(_VariadicView.Tree<_ContextMenuContainer.Container<AnyView>, AnyView>.self)
    }
}

extension _VariadicView.Tree: JsonView, DynaCodable where Root : _VariadicView_ViewRoot, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
//    public init(from decoder: Decoder, for dynaType: DynaType) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let root = try container.decodeAny(Root.self, forKey: .root, dynaType: dynaType[0])
//        let content = try container.decodeAny(Content.self, forKey: .content, dynaType: dynaType[1])
//        self.init(root, content: { content })
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeAny(root, forKey: .root)
//        try container.encodeAny(content, forKey: .content)
//    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeAny(Root.self, forKey: .root, dynaType: dynaType[0])
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[1])
        self.init(root, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(root, forKey: .root)
        try container.encode(content, forKey: .content)
    }
}


//extension _VariadicView_Children { }
//DynaType.register(_VariadicView.Tree<JsonAnyVariadicViewRoot, AnyView>.self)
//struct JsonAnyVariadicViewRoot: _VariadicView_ViewRoot, DynaDecodable {
//    func body(children: _VariadicView.Children) -> Never { fatalError() }
//    public init(from decoder: Decoder, for dynaType: DynaType) throws { fatalError() }
//}

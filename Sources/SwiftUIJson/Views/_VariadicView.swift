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
        PType.register(_VariadicView.Tree<_ContextMenuContainer.Container<AnyView>, AnyView>.self)
    }
}

extension _VariadicView.Tree: IAnyView, DynaCodable where Root : _VariadicView_ViewRoot, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decodeAny(Root.self, forKey: .root, ptype: ptype[0])
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[1])
        self.init(root, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(root, forKey: .root)
        try container.encode(content, forKey: .content)
    }
}


//extension _VariadicView_Children { }
//PType.register(_VariadicView.Tree<JsonAnyVariadicViewRoot, AnyView>.self)
//struct JsonAnyVariadicViewRoot: _VariadicView_ViewRoot, DynaDecodable {
//    func body(children: _VariadicView.Children) -> Never { fatalError() }
//    public init(from decoder: Decoder, for ptype: PType) throws { fatalError() }
//}


@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
protocol _Tree_ViewRoot {
    init(any: Any)
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
class Tree<Root, Content> where Root : _Tree_ViewRoot, Content : View {
    let root: Root
    let content: Content
    init(root: Root, content: Content) {
        self.root = root
        self.content = content
    }
    init(any s: Any) {
        let m = Mirror.children(reflecting: s)
        root = Root(any: m["root"]!)
        content = m["content"]! as! Content
    }
}

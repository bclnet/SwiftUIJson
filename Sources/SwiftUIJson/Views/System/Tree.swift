//
//  Tree.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal protocol _Tree_ViewRoot {
    init(any: Any)
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal class Tree<Root, Content> where Root : _Tree_ViewRoot, Content : View {
    let root: Root
    let content: Content
    init(any s: Any) {
        let base = Mirror.children(reflecting: s)
        self.root = Root(any: base["root"]!)
        self.content = base["content"] as! Content
    }
    init(root: Root, content: Content) {
        self.root = root
        self.content = content
    }
}

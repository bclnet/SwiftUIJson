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

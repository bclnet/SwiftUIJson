//
//  HSplitView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension HSplitView: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        fatalError()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let root = try container.decodeIfPresent(_HStackLayout.self, forKey: .root) ?? _HStackLayout(alignment: .center, spacing: nil)
//        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
//        self.init(alignment: root.alignment, spacing: root.spacing) { content }
    }
    public func encode(to encoder: Encoder) throws {
        fatalError()
//        Mirror.assert(self, name: "HStack", keys: ["_tree"])
//        let tree = Mirror(reflecting: self).descendant("_tree") as! _VariadicView.Tree<_HStackLayout, Content>, root = tree.root
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if root.alignment != .center || root.spacing != nil { try container.encode(root, forKey: .root) }
//        try container.encode(tree.content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(HSplitView<AnyView>.self)
    }
}

//
//  TabView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, *)
@available(watchOS, unavailable)
extension TabView: IAnyView, DynaCodable where SelectionValue : Hashable, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case selection, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let selection = try? container.decodeIfPresent(Binding<SelectionValue>.self, forKey: .selection, ptype: ptype[0])
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[1])
        self.init(selection: selection, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "TabView", keys: ["selection", "content"])
        let m = Mirror.children(reflecting: self)
        let selection = m["selection"]! as? Binding<SelectionValue>
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(selection, forKey: .selection)
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        PType.register(TabView<AnyHashable, AnyView>.self)
    }
}

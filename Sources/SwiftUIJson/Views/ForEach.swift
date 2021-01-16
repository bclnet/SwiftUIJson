//
//  ForEach.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ForEach: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case root, content
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let root = (try? container.decodeIfPresent(_HStackLayout.self, forKey: .root)) ?? _HStackLayout(alignment: .center, spacing: nil)
//        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
//        self.init(alignment: root.alignment, spacing: root.spacing) { content }
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "ForEach", keys: ["contentID", "data", "content", "idGenerator"])
//        let m = Mirror.children(reflecting: self)
//        let contentID = m["contentID"]!
//        let data = m["data"]!
//        let content = m["content"]! as! (Int) -> Content
//        let idGenerator = m["idGenerator"]!
    }
    //: Register
    static func register() {
        PType.register(ForEach<AnyRandomAccessCollection<Any>, AnyHashable, AnyView>.self)
    }
}

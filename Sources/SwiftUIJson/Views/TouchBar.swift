//
//  TouchBar.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TouchBar: DynaCodable where Content : View, Content : DynaCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case content, id
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        if id == nil { self.init(content: { content }) }
        else { self.init(id: id!, content: { content }) }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "TouchBar", keys: ["content", "container"])
        let m = Mirror.children(reflecting: self)
        let content = m["content"]! as! Content
        let container2 = TouchBarContainer(any: m["container"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(container2.id, forKey: .id)
    }
    //: Register
    static func register() {
        PType.register(TouchBar<AnyView>.self)
    }
}

struct TouchBarContainer {
    let id: String?
    init(any: Any) {
        Mirror.assert(any, name: "TouchBarContainer", keys: ["id"])
        id = Mirror(reflecting: any).descendant("id")! as? String
    }
}

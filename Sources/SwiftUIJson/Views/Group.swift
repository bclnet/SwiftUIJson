//
//  SwiftUI.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

//extension Group: IAnyView, DynaCodable where Content : View {
//    public var anyView: AnyView { AnyView(self) }
//    //: Codable
//    enum CodingKeys: CodingKey {
//        case label, action
//    }
//    public init(from decoder: Decoder, for ptype: PType) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let label = try container.decode(Label.self, forKey: .label, ptype: ptype[0])
//        let action = try container.decodeAction(forKey: .action)
//        self.init(action: action, label: { label })
//    }
//    public func encode(to encoder: Encoder) throws {
//        Mirror.assert(self, name: "Button", keys: ["_label", "action"])
//        let m = Mirror.children(reflecting: self)
//        let label = m["_label"]! as! Text
//        let action = m["action"]! as! (() -> ())
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(label, forKey: .label)
//        try container.encodeAction(action, forKey: .action)
//    }
//    //: Register
//    static func register() {
//        PType.register(Group<AnyView>.self)
//    }
//}

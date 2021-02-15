//
//  Button.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Button: IAnyView, DynaCodable where Label : View, Label : DynaCodable {
    public var anyView: AnyView { AnyView(self) }

    //: Codable
    enum CodingKeys: CodingKey {
        case label, action
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Button", keys: ["action", "_label"])
        let m = Mirror.children(reflecting: self)
        let action = m["action"]! as! (() -> ())
        let label = m["_label"]! as! Text
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAction(action, forKey: .action)
        try container.encode(label, forKey: .label)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let action = try container.decodeAction(forKey: .action)
        let label = try container.decode(Label.self, forKey: .label, ptype: ptype[0])
        self.init(action: action, label: { label })
    }

    //: Register
    static func register() {
        PType.register(Button<AnyView>.self)
    }
}

//
//  Toggle.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Toggle: IAnyView, DynaCodable where Label : View, Label : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case label, isOn
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(Label.self, forKey: .label, ptype: ptype[0])
        let isOn = try container.decode(Binding<Bool>.self, forKey: .isOn)
        self.init(isOn: isOn, label: { label })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Toggle", keys: ["_label", "__isOn"])
        let m = Mirror.children(reflecting: self)
        let label = m["_label"]! as! Label
        let isOn = m["__isOn"]! as! Binding<Bool>
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(isOn, forKey: .isOn)
    }
    //: Register
    static func register() {
        PType.register(Toggle<AnyView>.self)
    }
}

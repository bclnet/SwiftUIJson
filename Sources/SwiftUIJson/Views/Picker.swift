//
//  Picker.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Picker: IAnyView, DynaCodable where Label : View, Label : DynaCodable, SelectionValue : Hashable, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case selection, label, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let selection = try container.decode(Binding<SelectionValue>.self, forKey: .selection, dynaType: dynaType[1])
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[2])
        self.init(selection: selection, label: label, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Picker", keys: ["selection", "label", "content"])
        let m = Mirror.children(reflecting: self)
        let selection = m["selection"]! as! Binding<SelectionValue>
        let label = m["label"]! as! Label
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selection, forKey: .selection)
        try container.encode(label, forKey: .label)
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(Picker<AnyView, AnyHashable, AnyView>.self)
    }
}

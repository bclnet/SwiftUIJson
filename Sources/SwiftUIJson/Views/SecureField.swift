//
//  SecureField.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension SecureField: IAnyView, DynaCodable where Label == Text {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case title, titleKey, text, onCommit
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decode(Binding<String>.self, forKey: .text)
        let onCommit = try container.decodeAction(forKey: .onCommit)
        if container.contains(.title) {
            let title = try container.decode(String.self, forKey: .title)
            self.init(title, text: text, onCommit: onCommit)
        }
        else if container.contains(.titleKey) {
            let titleKey = LocalizedStringKey(try container.decode(String.self, forKey: .titleKey))
            self.init(titleKey, text: text, onCommit: onCommit)
        }
        else { fatalError() }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "SecureField", keys: ["label", "text", "onCommit"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let text = m["text"]! as! Binding<String>
        let onCommit = m["onCommit"]! as! (() -> Void)
        Mirror.assert(label, name: "Text", keys: ["storage", "modifiers"])
        let m2 = Mirror.children(reflecting: label)
        let storage = Text.Storage(any: m2.child(named: "storage"))
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch storage {
        case .verbatim(let value): try container.encode(value, forKey: .title)
        case .anyTextStorage(let value): try container.encode(value.key.encodeValue, forKey: .titleKey)
        }
        try container.encode(text, forKey: .text)
        try container.encodeAction(onCommit, forKey: .onCommit)
    }
    //: Register
    static func register() {
        DynaType.register(SecureField<Text>.self)
    }
}

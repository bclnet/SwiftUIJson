//
//  TextField.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension TextField: IAnyView, DynaCodable where Label == Text {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case title, titleKey, text, onEditingChanged, onCommit
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decode(Binding<String>.self, forKey: .text)
        let onEditingChanged = try container.decodeAction(Bool.self, forKey: .onEditingChanged)
        let onCommit = try container.decodeAction(forKey: .onCommit)
        if container.contains(.title) {
            let title = try container.decode(String.self, forKey: .title)
            // does not support TextField(_:value:formatter:onEditingChanged:onCommit:)
            self.init(title, text: text, onEditingChanged: onEditingChanged, onCommit: onCommit)
        }
        else if container.contains(.titleKey) {
            let titleKey = LocalizedStringKey(try container.decode(String.self, forKey: .titleKey))
            // does not support TextField(_:value:formatter:onEditingChanged:onCommit:)
            self.init(titleKey, text: text, onEditingChanged: onEditingChanged, onCommit: onCommit) }
        else { fatalError() }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "TextField", keys: ["label", "_text", "onEditingChanged", "onCommit", "updatesContinuously", "_uncommittedText", "isSecure"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let text = m["_text"]! as! Binding<String>
        let onEditingChanged = m["onEditingChanged"]! as! ((Bool) -> Void)
        let onCommit = m["onCommit"]! as! (() -> Void)
        Mirror.assert(label, name: "Text", keys: ["storage", "modifiers"])
        let m2 = Mirror.children(reflecting: label)
        let storage = Text.Storage(any: m2["storage"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch storage {
        case .text(let value): try container.encode(value, forKey: .titleKey)
        case .verbatim(let value): try container.encode(value, forKey: .title)
        default: fatalError("Not Supported")
        }
        try container.encode(text, forKey: .text)
        try container.encodeAction(onCommit, forKey: .onCommit)
        try container.encodeAction(onEditingChanged, forKey: .onEditingChanged)
    }
    //: Register
    static func register() {
        PType.register(TextField<Text>.self)
    }
}

//extension _TextFieldStyleLabel {}

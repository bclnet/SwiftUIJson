//
//  List.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension List: IAnyView, DynaCodable where SelectionValue : Hashable, Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case content, action
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
//        let action = try container.decodeAction(forKey: .action)
//        self.init(action: action, label: { label })
        let selection: Binding<SelectionValue?>? = nil
        self.init(selection: selection, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "List", keys: ["content", "selection"])
        let m = Mirror.children(reflecting: self)
        let content = m["content"]! as! Content
//        let selection = Mirror.optionalAny(Binding_SelectionManagerBox<SelectionValue>.self, any: m["selection"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
//        try container.encodeAction(action, forKey: .action)
    }
    //: Register
    static func register() {
        DynaType.register(List<AnyHashable, AnyView>.self)
    }
}

struct Binding_SelectionManagerBox<Item>: Convertible where Item : Hashable {
    let binding: Binding<SelectionManagerBox<Item>>
    init(any: Any) {
        Mirror.assert(any, name: "Binding", keys: ["_value", "location", "transaction"])
        let m = Mirror.children(reflecting: any)
        let value = SelectionManagerBox<Item>(any: m["_value"]!)
//        let location = m["location"]! as! Any
//        let transaction = m["transaction"]! as! Transaction
        binding = Binding<SelectionManagerBox<Item>>.constant(value)
    }
}

struct SelectionManagerBox<Item> where Item : Hashable {
    let set: Set<Item>
    init(any: Any) {
        Mirror.assert(any, name: "SelectionManagerBox", keys: ["set"])
        set = Mirror(reflecting: any).descendant("set")! as! Set<Item>
    }
}

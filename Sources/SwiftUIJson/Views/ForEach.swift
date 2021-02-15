//
//  ForEach.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ForEach where Content : View {
    public func encode(to encoder: Encoder) throws where Content : DynaCodable, Data.Element : CodableKeyPath {
        Mirror.assert(self, name: "ForEach", keys: ["contentID", "data", "content", "idGenerator"])
        let m = Mirror.children(reflecting: self)
        let data = m["data"]! as! Data
        let content = m["content"]! as! (Data.Element) -> Content
        let idGenerator = IDGenerator(any: m["idGenerator"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeData(data, forKey: .data)
        let id = Data.Element.encodeKeyPath(idGenerator.keyPath)
        try container.encode(id, forKey: .id)
        let defaultValue = DataManager.defaultValue(Data.Element.self)
        try container.encode(content(defaultValue), forKey: .content)
    }
}

extension ForEach where Content : View {
    public func encode(to encoder: Encoder) throws where ID == Data.Element.ID, Content : View, Data.Element : Identifiable, Content : DynaCodable, Data.Element : CodableKeyPath {
        Mirror.assert(self, name: "ForEach", keys: ["contentID", "data", "content", "idGenerator"])
        let m = Mirror.children(reflecting: self)
        let data = m["data"]! as! Data
        let content = m["content"]! as! (Data.Element) -> Content
        let idGenerator = IDGenerator(any: m["idGenerator"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeData(data, forKey: .data)
//        let rootPath = \Data.Element.id == idGenerator.keyPath
        let id = Data.Element.encodeKeyPath(idGenerator.keyPath)
        try container.encode(id, forKey: .id)
        let defaultValue = DataManager.defaultValue(Data.Element.self)
        try container.encode(content(defaultValue), forKey: .content)
    }
}

extension ForEach where Content : View {
    public func encode(to encoder: Encoder) throws where Data == Range<Int>, ID == Int {
        Mirror.assert(self, name: "ForEach", keys: ["contentID", "data", "content", "idGenerator"])
        fatalError()
    }
}

extension ForEach: IAnyView, DynaDecodable, Encodable where Content : View {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case data, id, content
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
        fatalError()
    }
    
    //: Register
    static func register() {
        PType.register(ForEach<AnyRandomAccessCollection<Any>, AnyHashable, AnyView>.self)
    }
    
    struct IDGenerator {
        let keyPath: KeyPath<Data.Element, ID>
        init(any: Any) {
            Mirror.assert(any, name: "IDGenerator", keys: ["keyPath"])
            keyPath = Mirror(reflecting: any).descendant("keyPath")! as! KeyPath<Data.Element, ID>
        }
    }
}

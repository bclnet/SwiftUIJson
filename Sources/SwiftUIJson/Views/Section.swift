//
//  Section.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Section: IAnyView, DynaCodable where Parent : View, Parent : DynaCodable, Content : View, Content : DynaCodable, Footer : View, Footer : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case header, footer, content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let header = (try? container.decodeIfPresent(Parent.self, forKey: .header, dynaType: dynaType[0])) ?? AnyView(EmptyView()) as! Parent
        let footer = (try? container.decodeIfPresent(Footer.self, forKey: .footer, dynaType: dynaType[2])) ?? AnyView(EmptyView()) as! Footer
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[1])
        self.init(header: header, footer: footer, content: { content })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Section", keys: ["header", "footer", "content"])
        let m = Mirror.children(reflecting: self)
        let header = m["header"]! as! Parent
        let footer = m["footer"]! as! Footer
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        if Parent.self != EmptyView.self { try container.encode(header, forKey: .header) }
        if Footer.self != EmptyView.self { try container.encode(footer, forKey: .footer) }
        try container.encode(content, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(Section<AnyView, AnyView, AnyView>.self)
    }
}

//
//  _ContextMenuContainer.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

//protocol AnyMenuContext {}

struct StyleContextWriter<Context>: JsonViewModifier, ConvertibleCodable where Context : Codable {
    public init(any: Any) {
        Mirror.assert(any, name: "StyleContextWriter", keys: [])
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView { AnyView(content) }
    //: Codable
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

struct MenuContext: Codable {//: AnyMenuContext {}
    //: Codable
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

struct _ContextMenuContainer: ConvertibleCodable {
    let contextMenu: Any
    public init(any: Any) {
//        let m = Mirror.children(reflecting: any)
        Mirror.assert(any, name: "_ContextMenuContainer", keys: [])
        contextMenu = 0 //ContextMenu(menuItems: {Text("D")})
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    struct Container<Content>: _VariadicView_ViewRoot, ConvertibleDynaCodable where Content : View, Content : DynaCodable {
        let contextMenu: ContextMenu<Content>?
        let content: Content
        public init(any: Any) {
            Mirror.assert(any, name: "Container", keys: ["contextMenu", "content"])
            let m = Mirror.children(reflecting: any)
            contextMenu = Mirror.optionalAny(_ContextMenuContainer.self, any: m["contextMenu"]!)?.contextMenu as? ContextMenu<Content>
            content = (m["content"]! as! IAnyView).anyView as! Content
        }
        //: _VariadicView_ViewRoot
        func body(children: _VariadicView.Children) -> Content {
            contextMenu == nil
                ? AnyView(content.contextMenu(menuItems: { children })) as! Content
                : AnyView(content.contextMenu(contextMenu)) as! Content
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case contextMenu, content
        }
        public init(from decoder: Decoder, for dynaType: DynaType) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            contextMenu = try? container.decodeIfPresent(ContextMenu.self, forKey: .contextMenu)
            content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(contextMenu, forKey: .contextMenu)
            try container.encode(content, forKey: .content)
        }    
    }
    
    //: Register
    static func register() {
        DynaType.register(StyleContextWriter<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(MenuContext.self, namespace: "SwiftUI")
        DynaType.register(Container<AnyView>.self, any: [AnyView.self], namespace: "SwiftUI")
    }
}

//
//  _TouchBarModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension _TouchBarModifier: JsonViewModifier, DynaCodable where Content : DynaCodable {
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        AnyView(content.modifier(self))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case content
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(TouchBar<Content>.self, forKey: .content, dynaType: dynaType[0])
        self = (Capsule().touchBar(content) as! ModifiedContent<Capsule, _TouchBarModifier<Content>>).modifier
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "_TouchBarModifier", keys: ["touchBar"])
        let touchBar = Mirror(reflecting: self).descendant("touchBar")! as! TouchBar<Content>
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(touchBar, forKey: .content)
    }
    //: Register
    static func register() {
        DynaType.register(_TouchBarModifier<AnyView>.self, any: [AnyView.self])
    }
}

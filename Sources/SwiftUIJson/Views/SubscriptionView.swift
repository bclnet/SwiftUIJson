//
//  SubscriptionView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
import Combine

extension SubscriptionView: IAnyView, DynaCodable where PublisherType : Combine.Publisher, PublisherType : DynaCodable, Content : View, Content : DynaCodable, PublisherType.Failure == Never {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case content, publisher, action
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[1])
        let publisher = try container.decode(PublisherType.self, forKey: .publisher, dynaType: dynaType[0])
        let action = try container.decodeAction(PublisherType.Output.self, forKey: .action)
        self.init(content: content, publisher: publisher, action: action)
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "SubscriptionView", keys: ["content", "publisher", "action"])
        let m = Mirror.children(reflecting: self)
        let content = m["content"]! as! Content
        let publisher = m["publisher"]! as! PublisherType
        let action = m["action"]! as! ((PublisherType.Output) -> Void)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(publisher, forKey: .publisher)
        try container.encodeAction(action, forKey: .action)
    }
    //: Register
    static func register() {
//        DynaType.register(SubscriptionView<AnyPublisher<Any, Never>, AnyView>.self, any: [AnyPublisher<Any, Never>.self, AnyView.self])
        DynaType.register(SubscriptionView<PassthroughSubject<Any, Never>, AnyView>.self)
        DynaType.register(SubscriptionView<CurrentValueSubject<Any, Never>, AnyView>.self)
        DynaType.register(SubscriptionView<Timer.TimerPublisher, AnyView>.self)
    }
}

//
//  NavigationLink.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension NavigationLink: IAnyView, DynaCodable where Label : View, Label : DynaCodable, Destination : View, Destination : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case destination, isActive, label, isDetailLink
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let destination = try container.decode(Destination.self, forKey: .destination, dynaType: dynaType[1])
        let isActive = try container.decode(Binding<Bool>.self, forKey: .isActive)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let isDetailLink = (try? container.decodeIfPresent(Bool.self, forKey: .isDetailLink)) ?? true
        let s = NavigationLink(destination: destination, isActive: isActive, label: { label })
        self = isDetailLink ? s : s.isDetailLink(false) as! NavigationLink<Label, Destination>
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "NavigationLink", keys: ["destination", "_isActive", "label", "isDetailLink", "_isNavigationEnabled"])
        let m = Mirror.children(reflecting: self)
        let destination = m["destination"]! as! Destination
        let isActive = StateOrBinding<Bool>(any: m["_isActive"]!)
        let label = m["label"]! as! Label
        let isDetailLink = m["isDetailLink"]! as! Bool
//        let isNavigationEnabled = m["_isNavigationEnabled"]! as! Environment<NavigationEnabled>
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(destination, forKey: .destination)
        try container.encode(isActive.projectedValue, forKey: .isActive)
        try container.encode(label, forKey: .label)
        if !isDetailLink { try container.encode(isDetailLink, forKey: .isDetailLink) }
    }
    //: Register
    static func register() {
        DynaType.register(NavigationLink<AnyView, AnyView>.self)
    }
}

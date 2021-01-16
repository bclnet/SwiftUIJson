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
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let destination = try container.decode(Destination.self, forKey: .destination, ptype: ptype[1])
        let isActive = try container.decode(Binding<Bool>.self, forKey: .isActive)
        let label = try container.decode(Label.self, forKey: .label, ptype: ptype[0])
        let s = NavigationLink(destination: destination, isActive: isActive, label: { label })
        #if os(iOS)
        let isDetailLink = (try? container.decodeIfPresent(Bool.self, forKey: .isDetailLink)) ?? true
        self = isDetailLink ? s : s.isDetailLink(false) as! NavigationLink<Label, Destination>
        #else
        self = s
        #endif
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "NavigationLink", keys: ["destination", "_isActive", "label", "isDetailLink", "_isNavigationEnabled", "_triggerUpdateSeed"], keyMatch: .any)
        let m = Mirror.children(reflecting: self)
        let destination = m["destination"]! as! Destination
        let isActive = StateOrBinding<Bool>(any: m["_isActive"]!)
        let label = m["label"]! as! Label
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(destination, forKey: .destination)
        try container.encode(isActive.projectedValue, forKey: .isActive)
        try container.encode(label, forKey: .label)
        #if os(iOS)
        let isDetailLink = m["isDetailLink"]! as! Bool
        if !isDetailLink { try container.encode(isDetailLink, forKey: .isDetailLink) }
        #endif
    }
    //: Register
    static func register() {
        PType.register(NavigationLink<AnyView, AnyView>.self)
    }
}

//
//  Link.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Link: IAnyView, DynaCodable where Label : View, Label : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case label, destination
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let destination = try container.decode(URL.self, forKey: .destination)
        self.init(destination: destination, label: { label })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Link", keys: ["label", "destination"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let destination = LinkDestination(any: m["destination"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(destination.configuration.url, forKey: .destination)
    }
    //: Register
    static func register() {
        DynaType.register(Link<AnyView>.self)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct LinkDestination {
    let configuration: Configuration
    let _openURL: Environment<OpenURLAction>
    let _openSensitiveURL: Environment<OpenURLAction>
    init(any: Any) {
        Mirror.assert(any, name: "LinkDestination", keys: ["configuration", "_openURL", "_openSensitiveURL"])
        let m = Mirror.children(reflecting: any)
        configuration = Configuration(any: m["configuration"]!)
        _openURL = m["_openURL"]! as! Environment<OpenURLAction>
        _openSensitiveURL = m["_openSensitiveURL"]! as! Environment<OpenURLAction>
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct Configuration {
    let url: URL
    let isSensitive: Bool
    init(any: Any) {
        Mirror.assert(any, name: "Configuration", keys: ["url", "isSensitive"])
        let m = Mirror.children(reflecting: any)
        url = m["url"]! as! URL
        isSensitive = m["isSensitive"]! as! Bool
    }
}

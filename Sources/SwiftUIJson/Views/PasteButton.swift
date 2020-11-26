//
//  PasteButton.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension PasteButton: IAnyView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case supportedContentTypes, supportedTypes, validatingDataHandler
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let validatingDataHandler = try container.decodeFunc([NSItemProvider].self, (() -> ())?.self, forKey: .validatingDataHandler)
        if #available(macOS 11.0, *) {
            let supportedContentTypes = try container.decode([UTType].self, forKey: .supportedContentTypes)
            self.init(supportedContentTypes: supportedContentTypes, validator: validatingDataHandler, payloadAction: { _ in })
        }
        else {
            let supportedTypes = try container.decode([String].self, forKey: .supportedTypes)
            self.init(supportedTypes: supportedTypes, validator: validatingDataHandler, payloadAction: { _ in })
        }
    }
    public func encode(to encoder: Encoder) throws {
        fatalError("Not Supported: payloadAction missing")
        /*
         Mirror.assert(self, name: "PasteButton", keys: ["isEnabled", "supportedTypes", "supportedContentTypes", "validatingDataHandler"], keyMatch: .any)
         let m = Mirror.children(reflecting: self)
         let validatingDataHandler = m["validatingDataHandler"]! as! (([NSItemProvider]) -> (() -> ())?)
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encodeFunc(validatingDataHandler, forKey: .validatingDataHandler)
         if #available(macOS 11.0, *) {
         let supportedContentTypes = m["supportedContentTypes"]! as! [UTType]
         try container.encode(supportedContentTypes, forKey: .supportedContentTypes)
         } else {
         let supportedTypes = m["supportedTypes"]! as! [String]
         try container.encode(supportedTypes, forKey: .supportedTypes)
         }
         */
    }
    //: Register
    static func register() {
        DynaType.register(PasteButton.self)
    }
}

//
//  Bundle.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

public struct CodableBundle: Codable {
    public let bundle: Bundle
    //: Codable
    enum CodingKeys: CodingKey {
        case bundlePath
    }
    public init?(_ bundle: Bundle?) {
        guard let bundle = bundle else { return nil }
        self.bundle = bundle
    }
    public init(from decoder: Decoder) throws {
        //        var container = encoder.container(keyedBy: CodingKeys.self)
        //        try container.encode(self.bundlePath, forKey: .bundlePath)
        bundle = Bundle.main
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bundle.bundlePath, forKey: .bundlePath)
    }
}

//extension Bundle {
//    enum CodingKeys: CodingKey {
//        case bundlePath
//    }
//    public static func decode(from decoder: Decoder) throws -> Bundle {
////        var container = encoder.container(keyedBy: CodingKeys.self)
////        try container.encode(self.bundlePath, forKey: .bundlePath)
//        Bundle.main
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.bundlePath, forKey: .bundlePath)
//    }
//
//    public static func decodeValue(_ value: String) -> Bundle? { Bundle.init(path: value) }
//}

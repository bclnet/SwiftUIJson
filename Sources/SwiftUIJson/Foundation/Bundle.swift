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
        case main, path
    }
    public init?(_ bundle: Bundle?) {
        guard let bundle = bundle else { return nil }
        self.bundle = bundle
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if try container.decodeIfPresent(Bool.self, forKey: .main) ?? false {
            bundle = Bundle.main
            return
        }
        let path = try container.decode(String.self, forKey: .path)
        bundle = Bundle(path: path)!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if bundle == Bundle.main {
            try container.encode(true, forKey: .main)
            return
        }
        try container.encode(bundle.bundlePath, forKey: .path)
    }
}

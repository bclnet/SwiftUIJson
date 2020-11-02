//
//  Bundle.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

extension Bundle: WrapableCodeable {
    public var wrapValue: Bundle { self }
    //: Codable
    enum CodingKeys: CodingKey {
        case main, path
    }
    public static func decode(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if try container.decodeIfPresent(Bool.self, forKey: .main) ?? false {
            return Bundle.main as! Self
        }
        let path = try container.decode(String.self, forKey: .path)
        return Bundle(path: path)! as! Self
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if self == Bundle.main {
            try container.encode(true, forKey: .main)
            return
        }
        try container.encode(self.bundlePath, forKey: .path)
    }
}

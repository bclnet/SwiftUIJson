//
//  Bundle.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

extension Bundle: Encodable {
    enum CodingKeys: CodingKey {
        case bundlePath
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.bundlePath, forKey: .bundlePath)
    }
    
    public static func decodeValue(_ value: String) -> Bundle? { Bundle.init(path: value) }
}

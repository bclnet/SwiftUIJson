//
//  __DesignTimeSelectionIdentifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension __DesignTimeSelectionIdentifier: Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case identifier
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(String.self, forKey: .identifier)
        self.init(identifier)
    }

    //: Register
    static func register() {
        PType.register(__DesignTimeSelectionIdentifier.self)
    }
}

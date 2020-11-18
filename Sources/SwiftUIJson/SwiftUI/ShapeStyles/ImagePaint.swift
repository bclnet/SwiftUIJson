//
//  ImagePaint.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ImagePaint: FullyCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case image, sourceRect, scale
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let image = try container.decode(Image.self, forKey: .image)
        let sourceRect = try container.decodeIfPresent(CGRect.self, forKey: .sourceRect) ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        let scale = try container.decodeIfPresent(CGFloat.self, forKey: .scale) ?? 1
        self.init(image: image, sourceRect: sourceRect, scale: scale)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        if sourceRect != CGRect(x: 0, y: 0, width: 1, height: 1) { try container.encode(sourceRect, forKey: .sourceRect) }
        if scale != 1 { try container.encode(scale, forKey: .scale) }
    }
    //: Register
    static func register() {
        DynaType.register(ImagePaint.self)
    }
}

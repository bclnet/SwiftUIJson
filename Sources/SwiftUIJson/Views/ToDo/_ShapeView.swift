//
//  _ShapeView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _ShapeView: Encodable where Content : Shape, Style : ShapeStyle {
    public func encode(to encoder: Encoder) throws {
    }
}

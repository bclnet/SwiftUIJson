//
//  Slider.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider: Encodable where Label : View, ValueLabel : View {
    public func encode(to encoder: Encoder) throws {
    }
}
